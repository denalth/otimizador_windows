# Autoria: @denalth
# windowsupdate.ps1 - VERSAO SUPREMA 2.1
# Gerenciamento de atualizacoes do Windows.

function WindowsUpdate-Interactive {
    Write-Host "`n=== ATUALIZACOES DO WINDOWS ===" -ForegroundColor Cyan

    Write-Host "`n O que este modulo faz?" -ForegroundColor Yellow
    Write-Host " Permite verificar, instalar ou pausar atualizacoes do Windows." -ForegroundColor Gray
    Write-Host " Aviso: Algumas atualizacoes podem exigir reinicializacao.`n" -ForegroundColor Gray

    Write-Host " [Q] Voltar ao Menu Principal`n" -ForegroundColor DarkGray
    $check = Read-Host " Pressione ENTER para continuar ou Q para voltar"
    if ($check -eq 'q' -or $check -eq 'Q') { return }

    Write-Host "`n Escolha uma acao:" -ForegroundColor Cyan
    Write-Host " [1] Verificar atualizacoes disponiveis"
    Write-Host " [2] Pausar atualizacoes por 7 dias"
    Write-Host " [3] Retomar atualizacoes"
    Write-Host " [0] Voltar`n"

    $opt = Read-Host " Opcao"

    switch ($opt) {
        "1" {
            Write-Host "`n [ACAO] Verificar Atualizacoes" -ForegroundColor Cyan
            Write-Host " Iniciando verificacao... isso pode demorar alguns minutos.`n" -ForegroundColor Yellow
            try {
                $UpdateSession = New-Object -ComObject Microsoft.Update.Session
                $UpdateSearcher = $UpdateSession.CreateUpdateSearcher()
                Write-Host " Buscando atualizacoes..." -ForegroundColor Gray
                $SearchResult = $UpdateSearcher.Search("IsInstalled=0")
                if ($SearchResult.Updates.Count -eq 0) {
                    Write-Host " [OK] Nenhuma atualizacao pendente." -ForegroundColor Green
                } else {
                    Write-Host " [INFO] $($SearchResult.Updates.Count) atualizacao(es) encontrada(s):" -ForegroundColor Yellow
                    foreach ($Update in $SearchResult.Updates) {
                        Write-Host "   - $($Update.Title)" -ForegroundColor Gray
                    }
                }
            } catch {
                Write-Host " [ERRO] Falha ao verificar atualizacoes: $($_.Exception.Message)" -ForegroundColor Red
            }
        }
        "2" {
            Write-Host "`n [ACAO] Pausar Atualizacoes" -ForegroundColor Cyan
            Write-Host " O que vai acontecer: As atualizacoes serao pausadas por 7 dias.`n" -ForegroundColor Yellow
            try {
                $pauseDate = (Get-Date).AddDays(7).ToString("yyyy-MM-dd")
                Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\WindowsUpdate\UX\Settings" -Name "PauseUpdatesExpiryTime" -Value $pauseDate -Force
                Write-Host " [OK] Atualizacoes pausadas ate $pauseDate." -ForegroundColor Green
            } catch {
                Write-Host " [ERRO] Falha ao pausar: $($_.Exception.Message)" -ForegroundColor Red
            }
        }
        "3" {
            Write-Host "`n [ACAO] Retomar Atualizacoes" -ForegroundColor Cyan
            Write-Host " O que vai acontecer: A pausa sera removida e as atualizacoes voltarao ao normal.`n" -ForegroundColor Yellow
            try {
                Remove-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\WindowsUpdate\UX\Settings" -Name "PauseUpdatesExpiryTime" -Force -ErrorAction SilentlyContinue
                Write-Host " [OK] Atualizacoes retomadas." -ForegroundColor Green
            } catch {
                Write-Host " [ERRO] Falha ao retomar: $($_.Exception.Message)" -ForegroundColor Red
            }
        }
    }
}

