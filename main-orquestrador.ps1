# main-orquestrador.ps1 - VERSAO SUPREMA DEFINITIVA 2.1
# Orquestrador modular para Windows 11 - Dev / Gaming / Performance

# === CONFIGURACAO INICIAL ===
$ErrorActionPreference = "Continue"
$scriptPath = $MyInvocation.MyCommand.Definition
$scriptDir = Split-Path -Parent $scriptPath
if ([string]::IsNullOrEmpty($scriptDir)) { $scriptDir = $PWD }
$modulesDir = Join-Path $scriptDir "modules"

# === AUTO-ELEVACAO ===
$CurrentPrincipal = New-Object Security.Principal.WindowsPrincipal([Security.Principal.WindowsIdentity]::GetCurrent())
if (-not $CurrentPrincipal.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
    Write-Host " O script precisa de permissoes de Administrador." -ForegroundColor Yellow
    Write-Host " Tentando reiniciar automaticamente..." -ForegroundColor Cyan
    Start-Sleep -Seconds 1
    
    $NewProcess = New-Object System.Diagnostics.ProcessStartInfo "PowerShell"
    $NewProcess.Arguments = "-NoProfile -ExecutionPolicy Bypass -File `"$scriptPath`""
    $NewProcess.Verb = "RunAs"
    
    try {
        [System.Diagnostics.Process]::Start($NewProcess) | Out-Null
        Write-Host " Nova janela solicitada. Fechando esta..." -ForegroundColor Gray
        Start-Sleep -Seconds 2
        Exit
    } catch {
        Write-Host "`n [ERRO] Falha na auto-elevacao." -ForegroundColor Red
        Read-Host " Pressione Enter para sair"
        Exit
    }
}

# === BANNER ===
function Show-Banner {
    Clear-Host
    Write-Host ""
    Write-Host "  ================================================================" -ForegroundColor Cyan
    Write-Host "  |                                                              |" -ForegroundColor Cyan
    Write-Host "  |        WINDOWS OPTIMIZER - VERSAO 2.1 SUPREMA                |" -ForegroundColor Cyan
    Write-Host "  |        Para Devs, Gamers e Power Users                       |" -ForegroundColor Cyan
    Write-Host "  |                                                              |" -ForegroundColor Cyan
    Write-Host "  ================================================================" -ForegroundColor Cyan
    Write-Host ""
}

# === CARREGAMENTO DE MODULOS ===
$moduleFiles = @(
    "utils.ps1", "bloatwares.ps1", "services.ps1", "energy.ps1", 
    "visuals.ps1", "wsl2.ps1", "devtools.ps1", "sdks.ps1", 
    "cleanup.ps1", "windowsupdate.ps1", "privacy.ps1", 
    "gaming.ps1", "network.ps1"
)

Write-Host "Carregando modulos..." -ForegroundColor Cyan
$loadedCount = 0
foreach ($m in $moduleFiles) {
    $path = Join-Path $modulesDir $m
    if (Test-Path $path) {
        try { 
            . $path
            Write-Host "  [OK] $m" -ForegroundColor Green
            $loadedCount++ 
        } catch { 
            Write-Host "  [ERRO] $m - $($_.Exception.Message)" -ForegroundColor Red 
        }
    } else {
        Write-Host "  [FALTA] $m" -ForegroundColor Yellow
    }
}
Write-Host ""

# === INICIALIZACAO DE LOG ===
try {
    if (Get-Command Initialize-Log -ErrorAction SilentlyContinue) {
        $global:LogFile = Initialize-Log -baseDir "$env:USERPROFILE\OrquestradorLogs"
    } else {
        $logDir = "C:\OrquestradorLogs"
        if (-not (Test-Path $logDir)) { New-Item $logDir -ItemType Directory -Force | Out-Null }
        $global:LogFile = Join-Path $logDir "fallback.log"
    }
} catch {
    $global:LogFile = "C:\OrquestradorLogs\fallback.log"
}

Start-Sleep -Seconds 1

# === MENU PRINCIPAL ===
function Show-MainMenu {
    Show-Banner
    Write-Host " Log: $global:LogFile" -ForegroundColor DarkGray
    Write-Host ""
    Write-Host " ============================================================" -ForegroundColor DarkCyan
    Write-Host "  [1] Remover Bloatwares (Apps pre-instalados)" -ForegroundColor White
    Write-Host "  [2] Gerenciar Servicos (Performance)" -ForegroundColor White
    Write-Host "  [3] Plano de Energia (Ultimate Performance)" -ForegroundColor White
    Write-Host "  [4] Ajustes Visuais (Animacoes/Tema)" -ForegroundColor White
    Write-Host "  [5] Configurar WSL2 (Linux no Windows)" -ForegroundColor White
    Write-Host " ------------------------------------------------------------" -ForegroundColor DarkGray
    Write-Host "  [6] Instalar Ferramentas de Dev" -ForegroundColor Cyan
    Write-Host "  [7] Instalar SDKs e Linguagens" -ForegroundColor Cyan
    Write-Host "  [8] Privacidade e Telemetria" -ForegroundColor Yellow
    Write-Host "  [9] Otimizacoes para Gaming" -ForegroundColor Yellow
    Write-Host " [10] Configuracoes de Rede e DNS" -ForegroundColor Yellow
    Write-Host " ------------------------------------------------------------" -ForegroundColor DarkGray
    Write-Host " [11] Limpeza do Sistema (Profunda)" -ForegroundColor Magenta
    Write-Host " [12] Atualizacoes do Windows" -ForegroundColor Magenta
    Write-Host " [13] Inicializar Repositorio Git" -ForegroundColor Magenta
    Write-Host " ------------------------------------------------------------" -ForegroundColor DarkGray
    Write-Host "  [0] Sair" -ForegroundColor Red
    Write-Host " ============================================================" -ForegroundColor DarkCyan
    Write-Host ""
}

# === LOOP PRINCIPAL ===
do {
    Show-MainMenu
    $choice = Read-Host " Escolha uma opcao"
    switch ($choice) {
        "1" { if (Get-Command Remove-Bloatwares-Interactive -ErrorAction SilentlyContinue) { Remove-Bloatwares-Interactive } else { Write-Host " Modulo nao carregado." -ForegroundColor Red } }
        "2" { if (Get-Command Services-Interactive -ErrorAction SilentlyContinue) { Services-Interactive } else { Write-Host " Modulo nao carregado." -ForegroundColor Red } }
        "3" { if (Get-Command Enable-UltimatePerformance-Interactive -ErrorAction SilentlyContinue) { Enable-UltimatePerformance-Interactive } else { Write-Host " Modulo nao carregado." -ForegroundColor Red } }
        "4" { if (Get-Command Adjust-Visuals-Interactive -ErrorAction SilentlyContinue) { Adjust-Visuals-Interactive } else { Write-Host " Modulo nao carregado." -ForegroundColor Red } }
        "5" { if (Get-Command Setup-WSL2-Interactive -ErrorAction SilentlyContinue) { Setup-WSL2-Interactive } else { Write-Host " Modulo nao carregado." -ForegroundColor Red } }
        "6" { if (Get-Command Install-DevTools-Interactive -ErrorAction SilentlyContinue) { Install-DevTools-Interactive } else { Write-Host " Modulo nao carregado." -ForegroundColor Red } }
        "7" { if (Get-Command Install-SDKs-Interactive -ErrorAction SilentlyContinue) { Install-SDKs-Interactive } else { Write-Host " Modulo nao carregado." -ForegroundColor Red } }
        "8" { if (Get-Command Privacy-Interactive -ErrorAction SilentlyContinue) { Privacy-Interactive } else { Write-Host " Modulo nao carregado." -ForegroundColor Red } }
        "9" { if (Get-Command Gaming-Interactive -ErrorAction SilentlyContinue) { Gaming-Interactive } else { Write-Host " Modulo nao carregado." -ForegroundColor Red } }
        "10" { if (Get-Command Network-Interactive -ErrorAction SilentlyContinue) { Network-Interactive } else { Write-Host " Modulo nao carregado." -ForegroundColor Red } }
        "11" { if (Get-Command System-Cleanup-Interactive -ErrorAction SilentlyContinue) { System-Cleanup-Interactive } else { Write-Host " Modulo nao carregado." -ForegroundColor Red } }
        "12" { if (Get-Command WindowsUpdate-Interactive -ErrorAction SilentlyContinue) { WindowsUpdate-Interactive } else { Write-Host " Modulo nao carregado." -ForegroundColor Red } }
        "13" { if (Get-Command Init-GitRepo -ErrorAction SilentlyContinue) { Init-GitRepo -scriptDir $scriptDir } else { Write-Host " Modulo nao carregado." -ForegroundColor Red } }
        "0" { break }
    }
    if ($choice -ne "0" -and $choice -ne "") { 
        Write-Host "`n Pressione ENTER para voltar ao menu..." -ForegroundColor DarkGray
        Read-Host | Out-Null 
    }
} while ($choice -ne "0")

Write-Host "`n Obrigado por usar o Otimizador Windows!" -ForegroundColor Green
