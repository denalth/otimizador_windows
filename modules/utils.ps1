# utils.ps1 - VERSAO SUPREMA 2.1
# Funcoes utilitarias: Logging, Confirmacao, Execucao Segura.

function Initialize-Log {
    param([string]$baseDir)
    if (-not (Test-Path $baseDir)) { 
        New-Item -Path $baseDir -ItemType Directory -Force | Out-Null 
    }
    $timestamp = (Get-Date).ToString("yyyyMMdd_HHmmss")
    $logFile = Join-Path $baseDir "log_$timestamp.txt"
    "--- LOG INICIADO EM $((Get-Date).ToString()) ---" | Out-File $logFile -Encoding UTF8
    return $logFile
}

function Log-Info {
    param([string]$msg)
    $line = "[INFO] $msg"
    Write-Host $line -ForegroundColor Green
    if ($global:LogFile -and (Test-Path $global:LogFile)) { 
        $line | Out-File $global:LogFile -Append -Encoding UTF8
    }
}

function Log-Warning {
    param([string]$msg)
    $line = "[AVISO] $msg"
    Write-Host $line -ForegroundColor Yellow
    if ($global:LogFile -and (Test-Path $global:LogFile)) { 
        $line | Out-File $global:LogFile -Append -Encoding UTF8
    }
}

function Log-Error {
    param([string]$msg)
    $line = "[ERRO] $msg"
    Write-Host $line -ForegroundColor Red
    if ($global:LogFile -and (Test-Path $global:LogFile)) { 
        $line | Out-File $global:LogFile -Append -Encoding UTF8
    }
}

function Log-Success {
    param([string]$msg)
    $line = "[OK] $msg"
    Write-Host $line -ForegroundColor Cyan
    if ($global:LogFile -and (Test-Path $global:LogFile)) { 
        $line | Out-File $global:LogFile -Append -Encoding UTF8
    }
}

function Confirm-YesNo {
    param([string]$title)
    $choices = [System.Management.Automation.Host.ChoiceDescription[]]@(
        (New-Object System.Management.Automation.Host.ChoiceDescription "&Sim", "Confirmar"),
        (New-Object System.Management.Automation.Host.ChoiceDescription "&Nao", "Cancelar")
    )
    $result = $host.UI.PromptForChoice("Confirmacao", $title, $choices, 1)
    return ($result -eq 0)
}

function Run-Safe {
    param(
        [scriptblock]$action,
        [string]$description
    )
    try {
        & $action
        Log-Success "$description"
    } catch {
        Log-Error "$description - Falha: $($_.Exception.Message)"
    }
}

function Create-SystemRestorePoint {
    Log-Info "Criando ponto de restauracao..."
    try {
        Enable-ComputerRestore -Drive "C:\" -ErrorAction SilentlyContinue
        Checkpoint-Computer -Description "Otimizador_Windows" -RestorePointType "MODIFY_SETTINGS" -ErrorAction Stop
        Log-Success "Ponto de restauracao criado."
    } catch {
        Log-Warning "Nao foi possivel criar ponto de restauracao: $($_.Exception.Message)"
    }
}

function Init-GitRepo {
    param([string]$scriptDir)
    if (Test-Path (Join-Path $scriptDir ".git")) { 
        Log-Warning "Repositorio Git ja existe."
        return 
    }
    Run-Safe -action { 
        git init $scriptDir
        git -C $scriptDir add .
        git -C $scriptDir commit -m "feat: initial commit"
    } -description "Inicializar Git"
}
