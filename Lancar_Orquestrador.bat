# Autoria: @denalth
@echo off
:: ==========================================================
:: LAUNCHER ORQUESTRADOR WINDOWS 2.1
:: Garante que o PowerShell rode com ExecutionPolicy Bypass
:: ==========================================================
TITLE Iniciando Orquestrador...
color 0b

echo.
echo  [!] Iniciando o Orquestrador Windows...
echo  [!] Solicitando permissoes e ajustando politicas...
echo.

cd /d "%~dp0"

:: Executa o PowerShell ignorando a politica de bloqueio
powershell.exe -NoProfile -ExecutionPolicy Bypass -File "main-orquestrador.ps1"

:: Se houver erro critico e o script fechar anormalmente, avisa o usuario
if %errorlevel% neq 0 (
    color 0c
    echo.
    echo  [ERRO] O script foi encerrado inesperadamente.
    echo  Verifique se o arquivo 'main-orquestrador.ps1' esta na mesma pasta.
    pause
)

