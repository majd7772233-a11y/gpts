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
    $workerData = Join-Path $workerRoot 'data'
    $sessionFile = Join-Path $workerData 'open-webgpt-session.xml'
    if (-not (Test-Path -LiteralPath $workerConfig -PathType Leaf)) {
        Show-ErrorMessage 'لم أجد إعداد WebGPT Worker المحلي. شغّل إعداد Worker أولاً ثم أعد المحاولة.'
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
        $saved=Read-Session $sessionFile
        if ($saved) { & $nodePath $clientScript 'cancel' ([string]$saved.TaskId) 2>$null | Out-Null }
        if (Test-Path -LiteralPath $sessionFile) { Remove-Item -LiteralPath $sessionFile -Force }
        [System.Windows.Forms.MessageBox]::Show('The saved WebGPT session was revoked and removed for this Windows user.','Open WebGPT') | Out-Null
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

    $saved = if (-not $Rotate) { Read-Session $sessionFile } else { $null }
    $task = $null
    if ($saved -and ([IO.Path]::GetFullPath([string]$saved.ProjectPath) -eq $projectPath)) {
        $candidateToken = Get-PlainText $saved.Token
        try {
            $pathKey = (Get-Content -Raw -LiteralPath (Join-Path $workerData 'mcp-path.key')).Trim()
            $cfg = Get-Content -Raw -LiteralPath $workerConfig | ConvertFrom-Json
            $probe = @{jsonrpc='2.0';id=1;method='tools/call';params=@{name='get_task';arguments=@{token=$candidateToken}}} | ConvertTo-Json -Depth 6
            $response = Invoke-RestMethod -Uri ('http://127.0.0.1:' + $cfg.mcpPort + '/mcp/' + $pathKey) -Method Post -ContentType 'application/json' -Body $probe -TimeoutSec 10
            if (-not $response.result.isError) { $task = [pscustomobject]@{id=[string]$saved.TaskId;token=$candidateToken} }
        } catch { }
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
    Save-Session $sessionFile $projectPath ([string]$task.id) ([string]$task.token)
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
