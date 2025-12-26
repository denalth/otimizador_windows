# services.ps1 - VERSAO SUPREMA 2.1
# Gerenciamento de servicos do Windows.

function Services-Interactive {
    Log-Info "=== GERENCIAMENTO DE SERVICOS ==="

    Write-Host "`n O que isso faz?" -ForegroundColor Yellow
    Write-Host " Desativa servicos do Windows que consomem CPU/RAM em segundo plano." -ForegroundColor Gray
    Write-Host " Cada servico sera explicado antes de voce decidir desativa-lo.`n" -ForegroundColor Gray

    Write-Host " [Q] Voltar ao Menu Principal`n" -ForegroundColor DarkGray
    $check = Read-Host " Pressione ENTER para continuar ou Q para voltar"
    if ($check -eq 'q' -or $check -eq 'Q') { return }

    $services = @(
        @{Name = "DiagTrack"; Desc = "Telemetria e diagnostico da Microsoft. Envia dados de uso para a MS."; Risk = "Baixo"},
        @{Name = "SysMain"; Desc = "Superfetch: pre-carrega apps na RAM. Util em HDDs, dispensavel em SSDs."; Risk = "Baixo"},
        @{Name = "WSearch"; Desc = "Indexacao de arquivos para busca rapida. Pode consumir disco."; Risk = "Medio"},
        @{Name = "Spooler"; Desc = "Servico de impressao. Desnecessario se nao usa impressora."; Risk = "Baixo"},
        @{Name = "Fax"; Desc = "Servico de fax. Extremamente raro de ser usado."; Risk = "Baixo"},
        @{Name = "RemoteRegistry"; Desc = "Permite edicao remota do registro. Risco de seguranca."; Risk = "Baixo"},
        @{Name = "WerSvc"; Desc = "Relatorio de erros do Windows. Envia crashs para a MS."; Risk = "Baixo"},
        @{Name = "XboxGipSvc"; Desc = "Servico de acessorios Xbox. Dispensavel se nao usa controle Xbox."; Risk = "Baixo"}
    )

    foreach ($svc in $services) {
        $current = Get-Service $svc.Name -ErrorAction SilentlyContinue
        if ($current) {
            Write-Host "`n [$($svc.Name)]" -ForegroundColor Cyan
            Write-Host " $($svc.Desc)" -ForegroundColor Gray
            Write-Host " Status Atual: $($current.Status) | Risco de Desativar: $($svc.Risk)" -ForegroundColor Yellow
            Write-Host " Acao: O servico sera PARADO e configurado para NAO iniciar automaticamente.`n" -ForegroundColor Yellow

            if (Confirm-YesNo "Desativar $($svc.Name)?") {
                Stop-Service -Name $svc.Name -Force -ErrorAction SilentlyContinue
                Set-Service -Name $svc.Name -StartupType Disabled -ErrorAction SilentlyContinue
                Log-Success "$($svc.Name) desativado."
            } else {
                Log-Info "$($svc.Name) mantido."
            }
        }
    }
}
