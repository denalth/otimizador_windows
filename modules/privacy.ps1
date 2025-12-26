# Autoria: @denalth
# privacy.ps1 - VERSAO SUPREMA 2.1
# Configuracoes de privacidade e telemetria.

function Privacy-Interactive {
    Log-Info "=== PRIVACIDADE E TELEMETRIA ==="

    Write-Host "`n O que e Telemetria?" -ForegroundColor Yellow
    Write-Host " O Windows coleta dados sobre seu uso (apps abertos, erros, etc) e envia" -ForegroundColor Gray
    Write-Host " para a Microsoft. Essas configuracoes reduzem ou bloqueiam essa coleta.`n" -ForegroundColor Gray

    Write-Host " [Q] Voltar ao Menu Principal`n" -ForegroundColor DarkGray
    $check = Read-Host " Pressione ENTER para continuar ou Q para voltar"
    if ($check -eq 'q' -or $check -eq 'Q') { return }

    # Telemetria
    Write-Host "`n [ACAO] Reduzir Telemetria ao Minimo" -ForegroundColor Cyan
    Write-Host " O que vai acontecer: O nivel de coleta de dados sera reduzido para 'Security'." -ForegroundColor Yellow
    Write-Host " Isso ainda permite updates de seguranca, mas bloqueia dados de uso.`n" -ForegroundColor Gray
    if (Confirm-YesNo "Reduzir telemetria?") {
        Run-Safe -action {
            $path = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\DataCollection"
            if (-not (Test-Path $path)) { New-Item -Path $path -Force | Out-Null }
            Set-ItemProperty -Path $path -Name "AllowTelemetry" -Value 0 -Type DWord
        } -description "Reduzir telemetria"
    }

    # Advertising ID
    Write-Host "`n [ACAO] Desativar ID de Publicidade" -ForegroundColor Cyan
    Write-Host " O que vai acontecer: O Windows deixara de usar um ID unico para rastrear" -ForegroundColor Yellow
    Write-Host " seus interesses e exibir anuncios personalizados.`n" -ForegroundColor Gray
    if (Confirm-YesNo "Desativar Advertising ID?") {
        Run-Safe -action {
            $path = "HKCU:\Software\Microsoft\Windows\CurrentVersion\AdvertisingInfo"
            if (-not (Test-Path $path)) { New-Item -Path $path -Force | Out-Null }
            Set-ItemProperty -Path $path -Name "Enabled" -Value 0 -Type DWord
        } -description "Desativar Advertising ID"
    }

    # Cortana
    Write-Host "`n [ACAO] Desativar Cortana" -ForegroundColor Cyan
    Write-Host " O que vai acontecer: A assistente virtual sera desativada completamente.`n" -ForegroundColor Yellow
    if (Confirm-YesNo "Desativar Cortana?") {
        Run-Safe -action {
            $path = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\Windows Search"
            if (-not (Test-Path $path)) { New-Item -Path $path -Force | Out-Null }
            Set-ItemProperty -Path $path -Name "AllowCortana" -Value 0 -Type DWord
        } -description "Desativar Cortana"
    }

    Log-Success "Configuracoes de privacidade aplicadas."
}

