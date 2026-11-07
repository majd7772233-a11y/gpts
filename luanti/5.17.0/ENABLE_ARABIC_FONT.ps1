# Luanti 5.17.0 - enable Arabic glyph coverage on Windows
# This changes font paths only. It does not modify worlds, games, mods, or translations.

$ErrorActionPreference = "Stop"

function Find-LuantiRoot {
    $current = Get-Item -LiteralPath $PSScriptRoot
    while ($null -ne $current) {
        $exe = Join-Path $current.FullName "bin\luanti.exe"
        $example = Join-Path $current.FullName "minetest.conf.example"
        if ((Test-Path -LiteralPath $exe -PathType Leaf) -and
            (Test-Path -LiteralPath $example -PathType Leaf)) {
            return $current.FullName
        }
        $current = $current.Parent
    }
    throw "لم أجد مجلد Luanti المحمول. ضع هذا السكربت داخل مجلد 5.17.0 الذي يحتوي bin\luanti.exe."
}

function Set-ConfigValue {
    param(
        [System.Collections.Generic.List[string]]$Lines,
        [string]$Name,
        [string]$Value
    )

    $pattern = "^\s*" + [Regex]::Escape($Name) + "\s*="
    for ($i = $Lines.Count - 1; $i -ge 0; $i--) {
        if ($Lines[$i] -match $pattern) {
            $Lines.RemoveAt($i)
        }
    }
    $Lines.Add("$Name = $Value")
}

try {
    $root = Find-LuantiRoot
    $configPath = Join-Path $root "minetest.conf"
    $fontsDir = Join-Path $env:WINDIR "Fonts"

    # Tahoma is preferred because it has broad Arabic glyph coverage.
    # Segoe UI and Arial are fallbacks for customized Windows installations.
    $candidates = @(
        [pscustomobject]@{
            Name = "Tahoma"
            Regular = "tahoma.ttf"
            Bold = "tahomabd.ttf"
            Italic = "tahoma.ttf"
            BoldItalic = "tahomabd.ttf"
        },
        [pscustomobject]@{
            Name = "Segoe UI"
            Regular = "segoeui.ttf"
            Bold = "segoeuib.ttf"
            Italic = "segoeuii.ttf"
            BoldItalic = "segoeuiz.ttf"
        },
        [pscustomobject]@{
            Name = "Arial"
            Regular = "arial.ttf"
            Bold = "arialbd.ttf"
            Italic = "ariali.ttf"
            BoldItalic = "arialbi.ttf"
        }
    )

    $chosen = $null
    foreach ($candidate in $candidates) {
        $regularPath = Join-Path $fontsDir $candidate.Regular
        if (Test-Path -LiteralPath $regularPath -PathType Leaf) {
            $chosen = $candidate
            break
        }
    }

    if ($null -eq $chosen) {
        throw "لم أجد Tahoma أو Segoe UI أو Arial داخل مجلد خطوط Windows: $fontsDir"
    }

    $resolveFont = {
        param([string]$FileName, [string]$Fallback)
        $path = Join-Path $fontsDir $FileName
        if (Test-Path -LiteralPath $path -PathType Leaf) {
            return $path
        }
        return (Join-Path $fontsDir $Fallback)
    }

    $regular = Join-Path $fontsDir $chosen.Regular
    $bold = & $resolveFont $chosen.Bold $chosen.Regular
    $italic = & $resolveFont $chosen.Italic $chosen.Regular
    $boldItalic = & $resolveFont $chosen.BoldItalic $chosen.Bold

    if (Test-Path -LiteralPath $configPath -PathType Leaf) {
        $stamp = Get-Date -Format "yyyyMMdd-HHmmss"
        $backupPath = "$configPath.backup-$stamp"
        Copy-Item -LiteralPath $configPath -Destination $backupPath
    }

    $lines = New-Object 'System.Collections.Generic.List[string]'
    if (Test-Path -LiteralPath $configPath -PathType Leaf) {
        foreach ($line in [System.IO.File]::ReadAllLines($configPath)) {
            $lines.Add($line)
        }
    }

    Set-ConfigValue -Lines $lines -Name "language" -Value "ar"

    # Use an installed Arabic-capable Windows font as the main face.
    # Keep fallback_font_path unchanged so Luanti retains its CJK fallback.
    Set-ConfigValue -Lines $lines -Name "font_path" -Value $regular
    Set-ConfigValue -Lines $lines -Name "font_path_bold" -Value $bold
    Set-ConfigValue -Lines $lines -Name "font_path_italic" -Value $italic
    Set-ConfigValue -Lines $lines -Name "font_path_bold_italic" -Value $boldItalic

    # Some GUI and console elements request the monospaced font mode.
    # Use the same Arabic-capable family there so those strings are not blank.
    Set-ConfigValue -Lines $lines -Name "mono_font_path" -Value $regular
    Set-ConfigValue -Lines $lines -Name "mono_font_path_bold" -Value $bold
    Set-ConfigValue -Lines $lines -Name "mono_font_path_italic" -Value $italic
    Set-ConfigValue -Lines $lines -Name "mono_font_path_bold_italic" -Value $boldItalic

    $utf8NoBom = New-Object System.Text.UTF8Encoding($false)
    [System.IO.File]::WriteAllLines($configPath, $lines.ToArray(), $utf8NoBom)

    Write-Host ""
    Write-Host "تم تحديث إعدادات خط Luanti بنجاح." -ForegroundColor Green
    Write-Host "المجلد: $root"
    Write-Host "الخط المستخدم: $($chosen.Name)"
    Write-Host "تم الإبقاء على خط fallback الأصلي ولم تُمس ملفات العوالم أو Mineclonia."
    Write-Host ""
    if (Get-Process -Name "luanti" -ErrorAction SilentlyContinue) {
        Write-Host "أغلق Luanti المفتوح ثم أعد تشغيله حتى تُحمّل الخطوط الجديدة." -ForegroundColor Yellow
    } else {
        Write-Host "شغّل Luanti الآن وافتح عالم Mineclonia." -ForegroundColor Green
    }
    Write-Host ""
    Write-Host "تنبيه: هذا يعالج غياب أشكال الحروف من الخط. محرك 5.17.0 لا يطبق بعدُ تشكيل العربية واتجاه RTL الكامل؛ لذلك قد تظهر الحروف منفصلة أو بترتيب غير صحيح."
}
catch {
    Write-Host ""
    Write-Host "[ERROR] $($_.Exception.Message)" -ForegroundColor Red
    exit 1
}
