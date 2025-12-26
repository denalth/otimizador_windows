# Autoria: @denalth
# devtools.ps1 - VERSAO SUPREMA 2.2
# Instalação de ferramentas via winget.

function Install-DevTools-Interactive {
    Log-Info "=== FERRAMENTAS DE DESENVOLVIMENTO ==="

    Write-Host "`n O que e isso?" -ForegroundColor Yellow
    Write-Host " Uma selecao de softwares essenciais para produtividade e dev automatizada." -ForegroundColor Gray

    Write-Host " [Q] Voltar ao Menu Principal`n" -ForegroundColor DarkGray
    $check = Read-Host " Pressione ENTER para continuar ou Q para voltar"
    if ($check -eq 'q' -or $check -eq 'Q') { return }

    $tools = @(
        @{Name = "VS Code"; ID = "Microsoft.VisualStudioCode"; Desc = "Editor de codigo profissional."},
        @{Name = "Git"; ID = "Git.Git"; Desc = "Controle de versao."},
        @{Name = "Windows Terminal"; ID = "Microsoft.WindowsTerminal"; Desc = "Terminal moderno do Windows."},
        @{Name = "Docker Desktop"; ID = "Docker.DockerDesktop"; Desc = "Gerenciamento de containers."},
        @{Name = "DBeaver"; ID = "dbeaver.dbeaver"; Desc = "Gerencidor universal de Bancos de Dados."}
    )

    foreach ($tool in $tools) {
        Write-Host "`n [$($tool.Name)]" -ForegroundColor Cyan
        Write-Host " $($tool.Desc)" -ForegroundColor Gray
        if (Confirm-YesNo "Instalar $($tool.Name)?") {
            Run-Safe -action {
                winget install --id $tool.ID -e --silent --accept-package-agreements --accept-source-agreements
            } -description "Instalar $($tool.Name)"
        }
    }
}

function Install-DevTools-Essentials {
    $essentialIds = @("Git.Git", "Microsoft.VisualStudioCode", "Microsoft.WindowsTerminal")
    foreach ($id in $essentialIds) {
        winget install --id $id -e --silent --accept-package-agreements --accept-source-agreements
    }
}
