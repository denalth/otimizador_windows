# Autoria: @denalth
# main-orquestrador.ps1

# === CONFIGURAÇÃO INICIAL ===
$ErrorActionPreference = "Continue"
$scriptPath = $MyInvocation.MyCommand.Definition
$scriptDir = Split-Path -Parent $scriptPath
if ([string]::IsNullOrEmpty($scriptDir)) { $scriptDir = $PWD }
$modulesDir = Join-Path $scriptDir "modules"

# === SISTEMA DE AUTENTICAÇÃO @denalth ===
function Authenticate-User {
    $attempts = 0
    $maxAttempts = 3
    $key = "@denalth"

    while ($attempts -lt $maxAttempts) {
        Clear-Host
        Write-Host "`n  ================================================================" -ForegroundColor Cyan
        Write-Host "  |                                                              |" -ForegroundColor Cyan
        Write-Host "  |   WINDOWS OPTIMIZER - SISTEMA DE SEGURANCA                   |" -ForegroundColor Cyan
        Write-Host "  |   Por: @denalth                                              |" -ForegroundColor Cyan
        Write-Host "  |                                                              |" -ForegroundColor Cyan
        Write-Host "  ================================================================" -ForegroundColor Cyan
        Write-Host ""

        $inputKey = Read-Host "  Digite a palavra-chave de acesso"

        if ($inputKey -eq $key) {
            Write-Host "`n  [ACESSO CONCEDIDO] Bem-vindo!`n" -ForegroundColor Green
            Start-Sleep -Seconds 1
            return $true
        } else {
            $attempts++
            Write-Host "`n  [ACESSO NEGADO] Palavra-chave incorreta ($attempts/$maxAttempts).`n" -ForegroundColor Red
            Start-Sleep -Seconds 2
        }
    }

    Write-Host "  Muitas tentativas falhas. O script sera encerrado." -ForegroundColor Red
    Start-Sleep -Seconds 2
    exit
}

# Iniciar autenticação
Authenticate-User

# === AUTO-ELEVAÇÃO ===
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
    Write-Host "  |        WINDOWS OPTIMIZER - VERSAO 2.2                       |" -ForegroundColor Cyan
    Write-Host "  |        by @denalth                                          |" -ForegroundColor Cyan
    Write-Host "  |                                                              |" -ForegroundColor Cyan
    Write-Host "  ================================================================" -ForegroundColor Cyan
    Write-Host ""
}

# === CARREGAMENTO DE MODULOS ===
$moduleFiles = @(
    "utils.ps1", "bloatwares.ps1", "services.ps1", "energy.ps1",
    "visuals.ps1", "wsl2.ps1", "devtools.ps1", "sdks.ps1",
    "cleanup.ps1", "windowsupdate.ps1", "privacy.ps1",
    "gaming.ps1", "network.ps1", "profiles.ps1", "backup.ps1", "health.ps1"
)

Write-Host "Carregando modulos..." -ForegroundColor Cyan
$loadedCount = 0
foreach ($m in $moduleFiles) {
    $path = Join-Path $modulesDir $m
    if (Test-Path $path) {
        try {
            . $path
            $loadedCount++
        } catch {
            Write-Host "  [ERRO] Falha ao carregar $m" -ForegroundColor Red
        }
    }
}

# === INICIALIZACAO DE LOG ===
try {
    if (Get-Command Initialize-Log -ErrorAction SilentlyContinue) {
        $global:LogFile = Initialize-Log -baseDir "$env:USERPROFILE\OrquestradorLogs"
    } else {
        $global:LogFile = "C:\OrquestradorLogs\fallback.log"
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
    Write-Host "  [1] Perfis de Otimizacao Sugeridos (Interface GUI)" -ForegroundColor Green
    Write-Host " ------------------------------------------------------------" -ForegroundColor DarkGray
    Write-Host "  [2] Remover Bloatwares (Apps pre-instalados)" -ForegroundColor White
    Write-Host "  [3] Gerenciar Servicos (Performance)" -ForegroundColor White
    Write-Host "  [4] Plano de Energia (Ultimate Performance)" -ForegroundColor White
    Write-Host "  [5] Ajustes Visuais (Animacoes/Tema)" -ForegroundColor White
    Write-Host "  [6] Configurar WSL2 (Linux no Windows)" -ForegroundColor White
    Write-Host " ------------------------------------------------------------" -ForegroundColor DarkGray
    Write-Host "  [7] Instalar Ferramentas de Dev" -ForegroundColor Cyan
    Write-Host "  [8] Instalar SDKs e Linguagens" -ForegroundColor Cyan
    Write-Host "  [9] Privacidade e Telemetria" -ForegroundColor Yellow
    Write-Host " [10] Otimizacoes para Gaming" -ForegroundColor Yellow
    Write-Host " [11] Configuracoes de Rede e DNS" -ForegroundColor Yellow
    Write-Host " ------------------------------------------------------------" -ForegroundColor DarkGray
    Write-Host " [12] Limpeza do Sistema (Profunda)" -ForegroundColor Magenta
    Write-Host " [13] Atualizacoes do Windows" -ForegroundColor Magenta
    Write-Host " [14] Inicializar Repositorio Git" -ForegroundColor Magenta
    Write-Host " [15] Backup e Restauracao (Undo)" -ForegroundColor Green
    Write-Host " [16] Diagnostico de Saude do Sistema" -ForegroundColor Green
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
        "1" { if (Get-Command Profiles-Interactive -ErrorAction SilentlyContinue) { Profiles-Interactive } }
        "2" { if (Get-Command Remove-Bloatwares-Interactive -ErrorAction SilentlyContinue) { Remove-Bloatwares-Interactive } }
        "3" { if (Get-Command Services-Interactive -ErrorAction SilentlyContinue) { Services-Interactive } }
        "4" { if (Get-Command Enable-UltimatePerformance-Interactive -ErrorAction SilentlyContinue) { Enable-UltimatePerformance-Interactive } }
        "5" { if (Get-Command Adjust-Visuals-Interactive -ErrorAction SilentlyContinue) { Adjust-Visuals-Interactive } }
        "6" { if (Get-Command Setup-WSL2-Interactive -ErrorAction SilentlyContinue) { Setup-WSL2-Interactive } }
        "7" { if (Get-Command Install-DevTools-Interactive -ErrorAction SilentlyContinue) { Install-DevTools-Interactive } }
        "8" { if (Get-Command Install-SDKs-Interactive -ErrorAction SilentlyContinue) { Install-SDKs-Interactive } }
        "9" { if (Get-Command Privacy-Interactive -ErrorAction SilentlyContinue) { Privacy-Interactive } }
        "10" { if (Get-Command Gaming-Interactive -ErrorAction SilentlyContinue) { Gaming-Interactive } }
        "11" { if (Get-Command Network-Interactive -ErrorAction SilentlyContinue) { Network-Interactive } }
        "12" { if (Get-Command System-Cleanup-Interactive -ErrorAction SilentlyContinue) { System-Cleanup-Interactive } }
        "13" { if (Get-Command WindowsUpdate-Interactive -ErrorAction SilentlyContinue) { WindowsUpdate-Interactive } }
        "14" { if (Get-Command Init-GitRepo -ErrorAction SilentlyContinue) { Init-GitRepo -scriptDir $scriptDir }
        "15" { if (Get-Command Backup-Interactive -ErrorAction SilentlyContinue) { Backup-Interactive } }
        "16" { if (Get-Command Health-Interactive -ErrorAction SilentlyContinue) { Health-Interactive } } }
        "0" { break }
    }
    if ($choice -ne "0" -and $choice -ne "") {
        Write-Host "`n Pressione ENTER para voltar ao menu..." -ForegroundColor DarkGray
        Read-Host | Out-Null
    }
} while ($choice -ne "0")

Write-Host "`n Obrigado por usar o Otimizador Windows, @denalth!" -ForegroundColor Green




