@echo off
setlocal
powershell.exe -NoLogo -NoProfile -ExecutionPolicy Bypass -File "%~dp0Open-WebGPT.ps1"
if errorlevel 1 (
    echo.
    echo Open WebGPT did not finish successfully.
    pause
)
endlocal
