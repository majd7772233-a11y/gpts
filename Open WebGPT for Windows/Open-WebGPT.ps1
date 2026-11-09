# Open-WebGPT.ps1
# Creates or reuses a WebGPT Worker task for the selected project folder.
# The bearer token is copied to the clipboard and stored only as a DPAPI-protected SecureString.

param([switch]$Revoke, [switch]$Rotate)

$ErrorActionPreference = 'Stop'

function Show-ErrorMessage {
    param([string]$Message)
    [System.Windows.Forms.MessageBox]::Show(
        $Message,
        'Open WebGPT',
        [System.Windows.Forms.MessageBoxButtons]::OK,
        [System.Windows.Forms.MessageBoxIcon]::Error
    ) | Out-Null
}

function Save-Session {
    param([string]$Path, [string]$ProjectPath, [string]$TaskId, [string]$Token)
    [pscustomobject]@{ ProjectPath=$ProjectPath; TaskId=$TaskId; Token=(ConvertTo-SecureString $Token -AsPlainText -Force); SavedUtc=[DateTime]::UtcNow.ToString('o') } |
        Export-Clixml -LiteralPath $Path -Force
}

function Read-Session {
    param([string]$Path)
    if (-not (Test-Path -LiteralPath $Path -PathType Leaf)) { return $null }
    try { $r=Import-Clixml -LiteralPath $Path; if ($r.ProjectPath -and $r.TaskId -and $r.Token -is [securestring]) { return $r } } catch { }
    return $null
}

function Get-PlainText {
    param([securestring]$Value)
    $p=[Runtime.InteropServices.Marshal]::SecureStringToBSTR($Value)
    try { [Runtime.InteropServices.Marshal]::PtrToStringBSTR($p) } finally { [Runtime.InteropServices.Marshal]::ZeroFreeBSTR($p) }
}

function Cancel-Session {
    param([string]$NodePath, [string]$ClientScript, [string]$TaskId)

    $output = & $NodePath $ClientScript 'cancel' $TaskId 2>$null
    $exitCode = $LASTEXITCODE
    if ($exitCode -ne 0) {
        throw 'The Worker did not confirm task cancellation.'
    }

    try {
        $result = (($output | Out-String).Trim() | ConvertFrom-Json)
    } catch {
        throw 'The Worker returned an unreadable cancellation response.'
    }

    if ($result.ok -ne $true) {
        throw 'The Worker did not confirm task cancellation.'
    }
}

try {
    Add-Type -AssemblyName System.Windows.Forms
    Add-Type -AssemblyName System.Drawing

    # Locate Node.js.
    $nodeCommand = Get-Command 'node.exe' -ErrorAction SilentlyContinue
    if (-not $nodeCommand) {
        $nodeCommand = Get-Command 'node' -ErrorAction SilentlyContinue
    }

    if (-not $nodeCommand) {
        $commonNodePaths = @(
            (Join-Path $env:ProgramFiles 'nodejs\node.exe'),
            (Join-Path $env:LOCALAPPDATA 'Programs\nodejs\node.exe')
        )
        $nodePath = $commonNodePaths |
            Where-Object { $_ -and (Test-Path -LiteralPath $_ -PathType Leaf) } |
            Select-Object -First 1
    } else {
        $nodePath = $nodeCommand.Source
    }

    if (-not $nodePath) {
        Show-ErrorMessage 'لم أجد Node.js. ثبّت Node.js أو أضفه إلى PATH ثم أعد المحاولة.'
        exit 1
    }

    # Use the same private profile as the installed Worker service. Keep the
    # older launcher profile only as a backwards-compatible fallback.
    $workerRoots = @(
        (Join-Path $HOME 'Documents\Codex\webgpt-private'),
        (Join-Path $HOME 'Documents\Codex\Open-WebGPT-Worker')
    )
    $workerRoot = $workerRoots | Where-Object { Test-Path -LiteralPath (Join-Path $_ 'config.json') -PathType Leaf } | Select-Object -First 1
    if (-not $workerRoot) {
        Show-ErrorMessage 'WebGPT Worker configuration was not found.'
        exit 1
    }
    $workerConfig = Join-Path $workerRoot 'config.json'
    if (-not (Test-Path -LiteralPath $workerConfig -PathType Leaf)) {
        Show-ErrorMessage 'لم أجد إعداد WebGPT Worker المحلي. شغّل إعداد Worker أولاً ثم أعد المحاولة.'
        exit 1
    }

    # Match the exact data directory selected by the Worker configuration.
    # Do not silently fall back to <workerRoot>\data when config.json points elsewhere.
    $cfg = Get-Content -Raw -LiteralPath $workerConfig | ConvertFrom-Json
    if ([string]::IsNullOrWhiteSpace([string]$cfg.dataDir)) {
        $workerData = Join-Path $HOME '.local\share\webgpt'
    } else {
        if (-not [System.IO.Path]::IsPathRooted([string]$cfg.dataDir)) {
            Show-ErrorMessage 'مسار dataDir في إعداد WebGPT Worker يجب أن يكون مساراً مطلقاً.'
            exit 1
        }
        $workerData = [System.IO.Path]::GetFullPath([string]$cfg.dataDir)
    }

    $sessionFile = Join-Path $workerData 'open-webgpt-session.xml'
    if (-not (Test-Path -LiteralPath (Join-Path $workerData 'controller.key') -PathType Leaf)) {
        Show-ErrorMessage 'لم أجد controller.key في مجلد بيانات WebGPT Worker المحدد في config.json. لم يتم إنشاء جلسة جديدة.'
        exit 1
    }
    if (-not (Test-Path -LiteralPath (Join-Path $workerData 'mcp-path.key') -PathType Leaf)) {
        Show-ErrorMessage 'لم أجد mcp-path.key في مجلد بيانات WebGPT Worker. تحقق من إعداد MCP قبل المتابعة.'
        exit 1
    }

    $env:WEBGPT_CONFIG = $workerConfig
    $env:WEBGPT_DATA_DIR = $workerData

    # Find the installed WebGPT skill without scanning the whole computer.
    $clientCandidates = @()

    if ($env:CODEX_HOME) {
        $clientCandidates += (Join-Path $env:CODEX_HOME 'skills\webgpt\scripts\client.mjs')
    }

    $clientCandidates += @(
        (Join-Path $HOME '.codex\skills\webgpt\scripts\client.mjs'),
        (Join-Path $HOME '.agents\skills\webgpt\scripts\client.mjs'),
        (Join-Path $HOME '.config\codex\skills\webgpt\scripts\client.mjs')
    )

    $clientScript = $clientCandidates |
        Where-Object { Test-Path -LiteralPath $_ -PathType Leaf } |
        Select-Object -First 1

    # Search only the normal Codex skill folders if the direct paths did not match.
    if (-not $clientScript) {
        $skillRoots = @(
            (Join-Path $HOME '.codex\skills'),
            (Join-Path $HOME '.agents\skills')
        )

        foreach ($root in $skillRoots) {
            if (Test-Path -LiteralPath $root -PathType Container) {
                $found = Get-ChildItem -LiteralPath $root -Filter 'client.mjs' -File -Recurse -ErrorAction SilentlyContinue |
                    Where-Object { $_.FullName -match '[\\/]webgpt[\\/]scripts[\\/]client\.mjs$' } |
                    Select-Object -First 1

                if ($found) {
                    $clientScript = $found.FullName
                    break
                }
            }
        }
    }

    if (-not $clientScript) {
        Show-ErrorMessage 'لم أجد WebGPT skill في مجلدات Codex المعتادة. تأكد من تثبيت WebGPT skill أولاً.'
        exit 1
    }

    if ($Revoke) {
        $saved = Read-Session $sessionFile
        if (-not $saved) {
            if (Test-Path -LiteralPath $sessionFile -PathType Leaf) {
                Show-ErrorMessage 'تعذر قراءة سجل الجلسة المحفوظ. أبقيت الملف كما هو ولم أحذف أي بيانات.'
            } else {
                Show-ErrorMessage 'لا توجد جلسة محفوظة لإلغائها في مجلد بيانات WebGPT Worker المحدد.'
            }
            exit 1
        }

        try {
            Cancel-Session $nodePath $clientScript ([string]$saved.TaskId)
        } catch {
            Show-ErrorMessage 'لم يؤكد WebGPT Worker إلغاء المهمة. أبقيت سجل الجلسة كما هو حتى لا نفقد إمكانية استعادتها.'
            exit 1
        }

        Remove-Item -LiteralPath $sessionFile -Force
        [System.Windows.Forms.MessageBox]::Show('تم تأكيد إلغاء مهمة WebGPT وحذف سجلها المحلي.','Open WebGPT') | Out-Null
        exit 0
    }

    # Let the user choose the project folder.
    $folderDialog = New-Object System.Windows.Forms.FolderBrowserDialog
    $folderDialog.Description = 'اختر مجلد المشروع الذي تريد ربطه بـ WebGPT'
    $folderDialog.ShowNewFolderButton = $false
    $folderDialog.RootFolder = [System.Environment+SpecialFolder]::MyComputer

    if ($folderDialog.ShowDialog() -ne [System.Windows.Forms.DialogResult]::OK) {
        exit 0
    }

    $projectPath = [System.IO.Path]::GetFullPath($folderDialog.SelectedPath)

    $saved = Read-Session $sessionFile
    if ((Test-Path -LiteralPath $sessionFile -PathType Leaf) -and -not $saved) {
        Show-ErrorMessage 'سجل الجلسة موجود لكنه غير قابل للقراءة. لم أنشئ جلسة أخرى حتى لا نترك مهمة قديمة نشطة دون سجل.'
        exit 1
    }

    $task = $null
    $reuseSavedSession = $false

    if ($saved -and -not $Rotate -and
        ([IO.Path]::GetFullPath([string]$saved.ProjectPath) -eq $projectPath)) {

        # A transport/probe failure is not proof that the saved token is invalid.
        # Stop here instead of silently creating a duplicate task.
        try {
            $candidateToken = Get-PlainText $saved.Token
            $pathKey = (Get-Content -Raw -LiteralPath (Join-Path $workerData 'mcp-path.key')).Trim()
            if ($pathKey -notmatch '^[a-f0-9]{64}
    # Copy the bearer token without displaying it or writing it to a file.
    try {
        Set-Clipboard -Value ([string]$task.token)
    } catch {
        # Keep the encrypted session record if cancellation cannot be confirmed.
        try {
            Cancel-Session $nodePath $clientScript ([string]$task.id)
            Remove-Item -LiteralPath $sessionFile -Force -ErrorAction SilentlyContinue
            Show-ErrorMessage 'تعذّر نسخ الرمز إلى الحافظة. تم تأكيد إلغاء المهمة وإزالة سجلها المحلي.'
        } catch {
            Show-ErrorMessage 'تعذّر نسخ الرمز، كما لم يمكن تأكيد إلغاء المهمة. أبقيت سجل الجلسة المشفر لاستعادتها؛ أعد تشغيل المشغّل بعد إصلاح الحافظة أو الاتصال.'
        }
        exit 1
    }

    # Open ChatGPT in the default browser.
    Start-Process 'https://chatgpt.com/'

    $connectionName = 'WebGPT Worker'
    if ($task.connection -and $task.connection.name) {
        $connectionName = [string]$task.connection.name
    }

    $message = @"
تم إنشاء جلسة المشروع بنجاح.

المجلد:
$projectPath

تم نسخ رمز الجلسة إلى الحافظة دون عرضه أو حفظه في ملف.

في محادثة ChatGPT:
1. اختر موصل WebGPT Worker.
2. الصق رمز الجلسة في رسالتك الأولى.
3. اكتب طلبك. بعد ذلك يمكن استخدام الجلسة نفسها في الطلبات التالية.

تنبيه: الرمز يمنح وصولاً إلى حساب Windows الذي يعمل عليه العامل، ومجلد المشروع ليس عزلاً أمنياً. لا تشارك الرمز مع أحد.

لإنهاء الجلسة، اطلب من ChatGPT إنهاء جلسة WebGPT وحفظ النتيجة النهائية.
"@

    [System.Windows.Forms.MessageBox]::Show(
        $message,
        'Open WebGPT',
        [System.Windows.Forms.MessageBoxButtons]::OK,
        [System.Windows.Forms.MessageBoxIcon]::Information
    ) | Out-Null

} catch {
    Show-ErrorMessage 'حدث خطأ غير متوقع أثناء تشغيل Open WebGPT. تحقق من تثبيت WebGPT Worker وإعداداته ثم أعد المحاولة.'
    exit 1
}
) { throw 'Invalid MCP route key.' }

            $mcpPort = if ($cfg.mcpPort) { [int]$cfg.mcpPort } else { 43137 }
            $probe = @{jsonrpc='2.0';id=1;method='tools/call';params=@{name='get_task';arguments=@{token=$candidateToken}}} | ConvertTo-Json -Depth 6
            $response = Invoke-RestMethod -Uri ('http://127.0.0.1:' + $mcpPort + '/mcp/' + $pathKey) -Method Post -ContentType 'application/json' -Body $probe -TimeoutSec 10

            if ($null -eq $response.result -or $null -eq $response.result.isError) {
                throw 'The Worker returned an unexpected MCP response.'
            }

            if (-not $response.result.isError -and $response.result.structuredContent.status -eq 'running') {
                $task = [pscustomobject]@{id=[string]$saved.TaskId;token=$candidateToken}
                $reuseSavedSession = $true
            }
        } catch {
            Show-ErrorMessage 'تعذر التحقق من الجلسة المحفوظة عبر MCP المحلي. لم أنشئ رمزاً جديداً ولم أحذف سجل الجلسة؛ أصلح اتصال العامل ثم أعد المحاولة.'
            exit 1
        }
    }

    # Revoke before replacing an older session, including explicit rotation.
    if ($saved -and -not $reuseSavedSession) {
        try {
            Cancel-Session $nodePath $clientScript ([string]$saved.TaskId)
        } catch {
            Show-ErrorMessage 'لم أستطع تأكيد إلغاء المهمة السابقة. أوقفت العملية وأبقيت سجلها؛ لم أنشئ مهمة بديلة.'
            exit 1
        }
        Remove-Item -LiteralPath $sessionFile -Force
    }

    if (-not $task) {
        # The 30-day value is a supervisor backup-check interval, not a token expiry.
        $rawOutput = & $nodePath $clientScript 'register' '--cwd' $projectPath '--backup-ms' '2592000000' 2>$null
        $commandExitCode = $LASTEXITCODE

        if ($commandExitCode -ne 0) {
            Show-ErrorMessage 'تعذّر إنشاء جلسة WebGPT. تأكد أن خدمة WebGPT Worker تعمل وأن إعدادات الاتصال سليمة.'
            exit 1
        }

        $jsonText = ($rawOutput | Out-String).Trim()
        try {
            $task = $jsonText | ConvertFrom-Json
        } catch {
            Show-ErrorMessage 'وصل رد غير متوقع من WebGPT Worker. لم أتمكن من قراءة بيانات الجلسة.'
            exit 1
        }

        if (-not $task.token -or -not $task.id) {
            Show-ErrorMessage 'لم يُرجع WebGPT Worker رمز جلسة صالحاً.'
            exit 1
        }

        try {
            Save-Session $sessionFile $projectPath ([string]$task.id) ([string]$task.token)
        } catch {
            try { Cancel-Session $nodePath $clientScript ([string]$task.id) } catch { }
            Show-ErrorMessage 'تعذر حفظ سجل الجلسة المشفر. أوقفت التسجيل وحاولت إلغاء المهمة الجديدة.'
            exit 1
        }
    }

    # Copy the bearer token without displaying it or writing it to a file.
    try {
        Set-Clipboard -Value ([string]$task.token)
    } catch {
        # Avoid leaving an unused running task if clipboard access failed.
        & $nodePath $clientScript 'cancel' ([string]$task.id) 2>$null | Out-Null
        Show-ErrorMessage 'تعذّر نسخ رمز الجلسة إلى الحافظة. أُلغيت الجلسة غير المستخدمة.'
        exit 1
    }

    # Open ChatGPT in the default browser.
    Start-Process 'https://chatgpt.com/'

    $connectionName = 'WebGPT Worker'
    if ($task.connection -and $task.connection.name) {
        $connectionName = [string]$task.connection.name
    }

    $message = @"
تم إنشاء جلسة المشروع بنجاح.

المجلد:
$projectPath

تم نسخ رمز الجلسة إلى الحافظة دون عرضه أو حفظه في ملف.

في محادثة ChatGPT:
1. اختر موصل WebGPT Worker.
2. الصق رمز الجلسة في رسالتك الأولى.
3. اكتب طلبك. بعد ذلك يمكن استخدام الجلسة نفسها في الطلبات التالية.

تنبيه: الرمز يمنح وصولاً إلى حساب Windows الذي يعمل عليه العامل، ومجلد المشروع ليس عزلاً أمنياً. لا تشارك الرمز مع أحد.

لإنهاء الجلسة، اطلب من ChatGPT إنهاء جلسة WebGPT وحفظ النتيجة النهائية.
"@

    [System.Windows.Forms.MessageBox]::Show(
        $message,
        'Open WebGPT',
        [System.Windows.Forms.MessageBoxButtons]::OK,
        [System.Windows.Forms.MessageBoxIcon]::Information
    ) | Out-Null

} catch {
    Show-ErrorMessage 'حدث خطأ غير متوقع أثناء تشغيل Open WebGPT. تحقق من تثبيت WebGPT Worker وإعداداته ثم أعد المحاولة.'
    exit 1
}
