# Autoria: @denalth
# gaming.ps1 - VERSAO SUPREMA 2.1
# Otimizacoes para gaming e baixa latencia.

function Gaming-Interactive {
    Log-Info "=== OTIMIZACOES PARA GAMING ==="

    Write-Host "`n O que essas otimizacoes fazem?" -ForegroundColor Yellow
    Write-Host " Configuram o Windows para priorizar jogos, reduzir latencia e maximizar FPS." -ForegroundColor Gray
    Write-Host " Inclui: Game Mode, GPU Scheduling, desativacao de overlays, tweaks de rede.`n" -ForegroundColor Gray

    Write-Host " [Q] Voltar ao Menu Principal`n" -ForegroundColor DarkGray
    $check = Read-Host " Pressione ENTER para continuar ou Q para voltar"
    if ($check -eq 'q' -or $check -eq 'Q') { return }

    # Game Mode
    Write-Host "`n [ACAO] Ativar Game Mode" -ForegroundColor Cyan
    Write-Host " O que vai acontecer: O Windows priorizara recursos para o jogo em primeiro plano.`n" -ForegroundColor Yellow
    if (Confirm-YesNo "Ativar Game Mode?") {
        Run-Safe -action {
            $path = "HKCU:\Software\Microsoft\GameBar"
            if (-not (Test-Path $path)) { New-Item -Path $path -Force | Out-Null }
            Set-ItemProperty -Path $path -Name "AllowAutoGameMode" -Value 1 -Type DWord
            Set-ItemProperty -Path $path -Name "AutoGameModeEnabled" -Value 1 -Type DWord
        } -description "Ativar Game Mode"
    }

    # Game DVR
    Write-Host "`n [ACAO] Desativar Game Bar/DVR" -ForegroundColor Cyan
    Write-Host " O que vai acontecer: O overlay de gravacao do Xbox sera desativado." -ForegroundColor Yellow
    Write-Host " Isso elimina uma fonte comum de stuttering em jogos.`n" -ForegroundColor Gray
    if (Confirm-YesNo "Desativar Game Bar/DVR?") {
        Run-Safe -action {
            $path = "HKCU:\Software\Microsoft\Windows\CurrentVersion\GameDVR"
            if (-not (Test-Path $path)) { New-Item -Path $path -Force | Out-Null }
            Set-ItemProperty -Path $path -Name "AppCaptureEnabled" -Value 0 -Type DWord
            $path2 = "HKCU:\System\GameConfigStore"
            if (-not (Test-Path $path2)) { New-Item -Path $path2 -Force | Out-Null }
            Set-ItemProperty -Path $path2 -Name "GameDVR_Enabled" -Value 0 -Type DWord
        } -description "Desativar Game DVR"
    }

    # HAGS
    Write-Host "`n [ACAO] Ativar Hardware-Accelerated GPU Scheduling (HAGS)" -ForegroundColor Cyan
    Write-Host " O que vai acontecer: A GPU assumira o controle do agendamento de tarefas graficas." -ForegroundColor Yellow
    Write-Host " Melhora a fluidez em jogos modernos. Requer GPU compativel e restart.`n" -ForegroundColor Gray
    if (Confirm-YesNo "Ativar HAGS?") {
        Run-Safe -action {
            Set-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Control\GraphicsDrivers" -Name "HwSchMode" -Value 2 -Type DWord
        } -description "Ativar HAGS"
    }

    Log-Success "Otimizacoes de gaming aplicadas. Reinicie para ativar HAGS."
}

