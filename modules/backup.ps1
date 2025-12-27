# Autoria: @denalth
# backup.ps1 - Modulo de Seguranca v5.0
# Sistema de Backup e Restauracao para acoes reversiveis

$global:BackupDir = "$env:USERPROFILE\WindowsOptimizerBackups"

function Initialize-BackupSystem {
    if (-not (Test-Path $global:BackupDir)) {
        New-Item -ItemType Directory -Path $global:BackupDir -Force | Out-Null
        Log-Info "Diretorio de backups criado: $global:BackupDir"
    }
}

function Backup-RegistryKey {
    param(
        [string]$KeyPath,
        [string]$BackupName
    )
    
    Initialize-BackupSystem
    
    $timestamp = Get-Date -Format "yyyyMMdd_HHmmss"
    $fileName = "$BackupName`_$timestamp.reg"
    $fullPath = Join-Path $global:BackupDir $fileName
    
    try {
        $regPath = $KeyPath -replace "HKLM:", "HKEY_LOCAL_MACHINE" -replace "HKCU:", "HKEY_CURRENT_USER"
        reg export $regPath $fullPath /y 2>$null
        
        if (Test-Path $fullPath) {
            Log-Success "Backup criado: $fileName"
            return $fullPath
        } else {
            Log-Error "Falha ao criar backup de $KeyPath"
            return $null
        }
    } catch {
        Log-Error "Erro no backup: $_"
        return $null
    }
}

function Restore-RegistryBackup {
    param([string]$BackupFile)
    
    if (Test-Path $BackupFile) {
        try {
            reg import $BackupFile 2>$null
            Log-Success "Backup restaurado: $(Split-Path $BackupFile -Leaf)"
            return $true
        } catch {
            Log-Error "Falha ao restaurar: $_"
            return $false
        }
    } else {
        Log-Error "Arquivo de backup nao encontrado."
        return $false
    }
}

function Create-SystemRestorePoint {
    param([string]$Description = "Windows Optimizer Checkpoint")
    
    Log-Info "Criando Ponto de Restauracao do Sistema..."
    
    try {
        Enable-ComputerRestore -Drive "C:\" -ErrorAction SilentlyContinue
        Checkpoint-Computer -Description $Description -RestorePointType "MODIFY_SETTINGS" -ErrorAction Stop
        Log-Success "Ponto de Restauracao criado: $Description"
        return $true
    } catch {
        Log-Warning "Nao foi possivel criar o ponto de restauracao. Isso pode exigir permissoes especiais."
        return $false
    }
}

function Show-BackupHistory {
    Initialize-BackupSystem
    
    $backups = Get-ChildItem $global:BackupDir -Filter "*.reg" | Sort-Object LastWriteTime -Descending
    
    if ($backups.Count -eq 0) {
        Write-Host "`n Nenhum backup encontrado." -ForegroundColor Yellow
        return
    }
    
    Write-Host "`n=== HISTORICO DE BACKUPS ===" -ForegroundColor Cyan
    $idx = 1
    foreach ($b in $backups) {
        Write-Host " [$idx] $($b.Name) - $($b.LastWriteTime)" -ForegroundColor White
        $idx++
    }
    
    return $backups
}

function Backup-Interactive {
    Log-Info "=== SISTEMA DE BACKUP E RESTAURACAO ==="
    
    Write-Host "`n O que voce deseja fazer?" -ForegroundColor Yellow
    Write-Host " [1] Criar Ponto de Restauracao do Windows" -ForegroundColor Cyan
    Write-Host " [2] Ver Historico de Backups do Registro" -ForegroundColor Cyan
    Write-Host " [3] Restaurar um Backup do Registro" -ForegroundColor Cyan
    Write-Host " [Q] Voltar ao Menu Principal`n" -ForegroundColor DarkGray

    $opt = Read-Host " Opcao"
    
    switch ($opt) {
        "1" {
            if (Confirm-YesNo "Criar um Ponto de Restauracao agora?") {
                Create-SystemRestorePoint -Description "Windows Optimizer v5.0 - Backup Manual"
            }
        }
        "2" {
            Show-BackupHistory
            Read-Host "`n Pressione ENTER para voltar"
        }
        "3" {
            $backups = Show-BackupHistory
            if ($backups) {
                $sel = Read-Host "`n Digite o numero do backup para restaurar (ou Q para cancelar)"
                if ($sel -ne 'q' -and $sel -match '^\d+$') {
                    $idx = [int]$sel - 1
                    if ($idx -ge 0 -and $idx -lt $backups.Count) {
                        if (Confirm-YesNo "Restaurar $($backups[$idx].Name)?") {
                            Restore-RegistryBackup -BackupFile $backups[$idx].FullName
                        }
                    }
                }
            }
        }
    }
}
