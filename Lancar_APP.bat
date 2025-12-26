@echo off
title Supreme Optimizer v3.0 - @denalth
cd /d "%~dp0"
powershell -NoProfile -ExecutionPolicy Bypass -File "Lancar_GUI.ps1"
if %ERRORLEVEL% NEQ 0 (
    echo.
    echo [ERRO] Algo deu errado. Veja a mensagem acima.
    pause
)
