# Open-WebGPT.ps1
# Creates or reuses a reusable WebGPT Worker task for the selected project.
# Session records are protected by Windows DPAPI through Export-Clixml.

param(
    [switch]$Revoke,
    [switch]$Rotate
)

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

function Show-InfoMessage {
    param([string]$Message)
    [System.Windows.Forms.MessageBox]::Show(
        $Message,
        'Open WebGPT',
        [System.Windows.Forms.MessageBoxButtons]::OK,
        [System.Windows.Forms.MessageBoxIcon]::Information
    ) | Out-Null
}

function Save-Session {
    param(
        [string]$Path,
        [string]$ProjectPath,
        [string]$TaskId,
        [string]$Token
    )

    $parent = Split-Path -Parent $Path
    if (-not (Test-Path -LiteralPath $parent -PathType Container)) {
        New-Item -ItemType Directory -Path $parent -Force | Out-Null
    }

    [pscustomobject]@{
        ProjectPath = $ProjectPath
        TaskId = $TaskId
        Token = (ConvertTo-SecureString $Token -AsPlainText -Force)
        SavedUtc = [DateTime]::UtcNow.ToString('o')
    } | Export-Clixml -LiteralPath $Path -Force
}

function Read-Session {
    param([string]$Path)

    if (-not (Test-Path -LiteralPath $Path -PathType Leaf)) {
        return $null
    }

    try {
        $record = Import-Clixml -LiteralPath $Path
        if ($record.ProjectPath -and $record.TaskId -and $record.Token -is [securestring]) {
            return $record
        }
    } catch {
        return $null
    }

    return $null
}

function Get-PlainText {
    param([securestring]$Value)

    $pointer = [Runtime.InteropServices.Marshal]::SecureStringToBSTR($Value)
    try {
        return [Runtime.InteropServices.Marshal]::PtrToStringBSTR($pointer)
    } finally {
        [Runtime.InteropServices.Marshal]::ZeroFreeBSTR($pointer)
    }
}

function Cancel-Session {
    param(
        [string]$NodePath,
        [string]$ClientScript,
        [string]$TaskId
    )

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

    $nodePath = $null
    if ($nodeCommand) {
        $nodePath = $nodeCommand.Source
    } else {
        $commonNodePaths = @(
            (Join-Path $env:ProgramFiles 'nodejs\node.exe'),
            (Join-Path $env:LOCALAPPDATA 'Programs\nodejs\node.exe')
        )
        $nodePath = $commonNodePaths |
            Where-Object { $_ -and (Test-Path -LiteralPath $_ -PathType Leaf) } |
            Select-Object -First 1
    }

    if (-not $nodePath) {
        Show-ErrorMessage 'Node.js was not found. Install Node.js or add it to PATH, then try again.'
        exit 1
    }

    # Prefer the current private Worker profile; retain the older profile as fallback.
    $workerRoots = @(
        (Join-Path $HOME 'Documents\Codex\webgpt-private'),
        (Join-Path $HOME 'Documents\Codex\Open-WebGPT-Worker')
    )

    $workerRoot = $workerRoots |
        Where-Object { Test-Path -LiteralPath (Join-Path $_ 'config.json') -PathType Leaf } |
        Select-Object -First 1

    if (-not $workerRoot) {
        Show-ErrorMessage 'WebGPT Worker configuration was not found.'
        exit 1
    }

    $workerConfig = Join-Path $workerRoot 'config.json'
    $cfg = Get-Content -Raw -LiteralPath $workerConfig | ConvertFrom-Json

    # Match the exact data directory used by the Worker service.
    if ([string]::IsNullOrWhiteSpace([string]$cfg.dataDir)) {
        $workerData = Join-Path $HOME '.local\share\webgpt'
    } else {
        if (-not [System.IO.Path]::IsPathRooted([string]$cfg.dataDir)) {
            Show-ErrorMessage 'The dataDir setting in config.json must be an absolute path.'
            exit 1
        }
        $workerData = [System.IO.Path]::GetFullPath([string]$cfg.dataDir)
    }

    if (-not (Test-Path -LiteralPath $workerData -PathType Container)) {
        Show-ErrorMessage 'The configured WebGPT Worker data directory does not exist.'
        exit 1
    }

    $controllerKeyFile = Join-Path $workerData 'controller.key'
    if (-not (Test-Path -LiteralPath $controllerKeyFile -PathType Leaf)) {
        Show-ErrorMessage 'controller.key was not found in the configured Worker data directory. No new task was created.'
        exit 1
    }

    $sessionFile = Join-Path $workerData 'open-webgpt-session.xml'
    $env:WEBGPT_CONFIG = $workerConfig
    $env:WEBGPT_DATA_DIR = $workerData

    # Find the installed WebGPT skill without scanning unrelated folders.
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
        Show-ErrorMessage 'The WebGPT skill client.mjs was not found in the usual Codex skill folders.'
        exit 1
    }

    # Revocation is available even when the public MCP route key is missing.
    if ($Revoke) {
        $saved = Read-Session $sessionFile

        if (-not $saved) {
            if (Test-Path -LiteralPath $sessionFile -PathType Leaf) {
                Show-ErrorMessage 'The saved session record cannot be read. The file was preserved.'
            } else {
                Show-ErrorMessage 'There is no saved WebGPT session to revoke.'
            }
            exit 1
        }

        try {
            Cancel-Session $nodePath $clientScript ([string]$saved.TaskId)
        } catch {
            Show-ErrorMessage 'The Worker did not confirm cancellation. The encrypted session record was preserved.'
            exit 1
        }

        Remove-Item -LiteralPath $sessionFile -Force
        Show-InfoMessage 'The Worker confirmed cancellation. The local session record was removed.'
        exit 0
    }

    # Let the user choose the project folder.
    $folderDialog = New-Object System.Windows.Forms.FolderBrowserDialog
    $folderDialog.Description = 'Choose the project folder to connect to WebGPT'
    $folderDialog.ShowNewFolderButton = $false
    $folderDialog.RootFolder = [System.Environment+SpecialFolder]::MyComputer

    if ($folderDialog.ShowDialog() -ne [System.Windows.Forms.DialogResult]::OK) {
        exit 0
    }

    $projectPath = [System.IO.Path]::GetFullPath($folderDialog.SelectedPath)

    $saved = Read-Session $sessionFile
    if ((Test-Path -LiteralPath $sessionFile -PathType Leaf) -and -not $saved) {
        Show-ErrorMessage 'A saved session file exists but cannot be read. No replacement task was created.'
        exit 1
    }

    $task = $null
    $reusedSession = $false
    $createdNewTask = $false

    # Reuse the same still-running task for the same project.
    if ($saved -and -not $Rotate -and
        ([IO.Path]::GetFullPath([string]$saved.ProjectPath) -eq $projectPath)) {

        try {
            $candidateToken = Get-PlainText $saved.Token

            $route = '/mcp'
            if ($cfg.publicMcp -eq $true) {
                $mcpPathKeyFile = Join-Path $workerData 'mcp-path.key'
                if (-not (Test-Path -LiteralPath $mcpPathKeyFile -PathType Leaf)) {
                    throw 'The configured public MCP path key is missing.'
                }

                $pathKey = (Get-Content -Raw -LiteralPath $mcpPathKeyFile).Trim()
                if ($pathKey -notmatch '^[a-f0-9]{64}$') {
                    throw 'The configured public MCP path key is invalid.'
                }

                $route = '/mcp/' + $pathKey
            }

            $mcpPort = if ($cfg.mcpPort) { [int]$cfg.mcpPort } else { 43137 }
            $probe = @{
                jsonrpc = '2.0'
                id = 1
                method = 'tools/call'
                params = @{
                    name = 'get_task'
                    arguments = @{ token = $candidateToken }
                }
            } | ConvertTo-Json -Depth 8

            $probeUri = 'http://127.0.0.1:' + $mcpPort + $route
            $response = Invoke-RestMethod -Uri $probeUri -Method Post -ContentType 'application/json' -Body $probe -TimeoutSec 10

            if ($null -eq $response.result -or $null -eq $response.result.isError) {
                throw 'The Worker returned an unexpected MCP response.'
            }

            if (-not $response.result.isError -and
                $response.result.structuredContent.status -eq 'running') {
                $task = [pscustomobject]@{
                    id = [string]$saved.TaskId
                    token = $candidateToken
                }
                $reusedSession = $true
            }
        } catch {
            # A connection/probe failure is not proof that the token is invalid.
            # Preserve the saved record and never silently create a duplicate task.
            Show-ErrorMessage 'The saved session could not be checked through the local MCP endpoint. No new task was created and the saved record was preserved.'
            exit 1
        }
    }

    # Cancel an older saved task before replacing or rotating it.
    if ($saved -and -not $reusedSession) {
        try {
            Cancel-Session $nodePath $clientScript ([string]$saved.TaskId)
        } catch {
            Show-ErrorMessage 'The previous task could not be confirmed as cancelled. The saved record was preserved and no replacement was created.'
            exit 1
        }

        Remove-Item -LiteralPath $sessionFile -Force
    }

    if (-not $task) {
        # This is the supervisor backup-check interval, not a token expiry.
        $rawOutput = & $nodePath $clientScript 'register' '--cwd' $projectPath '--backup-ms' '2592000000' 2>$null
        $commandExitCode = $LASTEXITCODE

        if ($commandExitCode -ne 0) {
            Show-ErrorMessage 'WebGPT could not register a task. Check that the Worker service is running and configured correctly.'
            exit 1
        }

        $jsonText = ($rawOutput | Out-String).Trim()
        try {
            $task = $jsonText | ConvertFrom-Json
        } catch {
            Show-ErrorMessage 'The Worker returned an unreadable task response.'
            exit 1
        }

        if (-not $task.token -or -not $task.id) {
            Show-ErrorMessage 'The Worker did not return a valid task token.'
            exit 1
        }

        try {
            Save-Session $sessionFile $projectPath ([string]$task.id) ([string]$task.token)
            $createdNewTask = $true
        } catch {
            try {
                Cancel-Session $nodePath $clientScript ([string]$task.id)
            } catch {
                # Do not expose task credentials in an error message.
            }

            Show-ErrorMessage 'The encrypted session record could not be saved. The launcher attempted to cancel the new task.'
            exit 1
        }
    }

    # Copy the bearer token without displaying it.
    try {
        Set-Clipboard -Value ([string]$task.token)
    } catch {
        if ($createdNewTask) {
            try {
                Cancel-Session $nodePath $clientScript ([string]$task.id)
                Remove-Item -LiteralPath $sessionFile -Force -ErrorAction SilentlyContinue
                Show-ErrorMessage 'The token could not be copied. The Worker confirmed cancellation and the local record was removed.'
            } catch {
                Show-ErrorMessage 'The token could not be copied and cancellation could not be confirmed. The encrypted session record was preserved.'
            }
        } else {
            Show-ErrorMessage 'The token could not be copied. The existing session remains active and its encrypted record was preserved.'
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
The project session is ready.

Project folder:
$projectPath

The task token has been copied to the clipboard. It was not displayed or written as plain text to a file.

In ChatGPT:
1. Select the "$connectionName" connector.
2. Paste the task token into your first message.
3. Continue using the same token for follow-up requests while the Worker task remains running.

Security note: The token grants access to the Windows account running the Worker. The project folder is a default working directory, not a security sandbox. Do not share the token.

To end this session, run this launcher with -Revoke. The launcher removes the local encrypted record only after the Worker confirms cancellation.
"@

    Show-InfoMessage $message

} catch {
    Show-ErrorMessage 'An unexpected error occurred while running Open WebGPT. Check the WebGPT Worker installation and configuration.'
    exit 1
}
