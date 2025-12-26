# Autoria: @denalth
# energy.ps1 - VERSAO SUPREMA 2.1
# Configuracoes de energia e performance.

function Enable-UltimatePerformance-Interactive {
    Log-Info "=== PLANO DE ENERGIA ==="

    Write-Host "`n O que e o Ultimate Performance?" -ForegroundColor Yellow
    Write-Host " E um plano de energia oculto do Windows que maximiza a velocidade do" -ForegroundColor Gray
    Write-Host " processador e elimina latencias de energia. Ideal para desktops e gamers." -ForegroundColor Gray
    Write-Host " Aviso: Aumenta o consumo de energia. Nao recomendado para notebooks na bateria.`n" -ForegroundColor Gray

    Write-Host " [Q] Voltar ao Menu Principal`n" -ForegroundColor DarkGray
    $check = Read-Host " Pressione ENTER para continuar ou Q para voltar"
    if ($check -eq 'q' -or $check -eq 'Q') { return }

    Write-Host "`n [ACAO] Ativar Plano Ultimate Performance" -ForegroundColor Cyan
    Write-Host " O que vai acontecer: O Windows revelara e ativara o plano oculto de energia maxima.`n" -ForegroundColor Yellow
    if (Confirm-YesNo "Ativar Ultimate Performance?") {
        $Guid = "e9a42b02-d5df-448d-aa00-03f14749eb61"
        try {
            powercfg -duplicatescheme $Guid | Out-Null
            powercfg /S $Guid
            Log-Success "Plano Ultimate Performance ativado."
        } catch {
            Log-Warning "Nao foi possivel ativar o plano."
        }
    }

    Write-Host "`n [ACAO] Desabilitar Hibernacao" -ForegroundColor Cyan
    Write-Host " O que vai acontecer: O arquivo hiberfil.sys sera removido, liberando GBs de espaco.`n" -ForegroundColor Yellow
    if (Confirm-YesNo "Desabilitar hibernacao?") {
        powercfg /h off
        Log-Success "Hibernacao desabilitada."
    }
}

