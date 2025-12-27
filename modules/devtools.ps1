# Autoria: @denalth
# devtools.ps1
# Instalação Selecionável de Ferramentas de Desenvolvimento

function Install-DevTools-Interactive {
    Log-Info "=== FERRAMENTAS DE DESENVOLVIMENTO ==="

    Write-Host "`n O que e isso?" -ForegroundColor Yellow
    Write-Host " Selecione as ferramentas de produtividade para instalar." -ForegroundColor Gray
    Write-Host " Digite os numeros separados por virgula (ex: 1,3) ou 'A' para Todas.`n" -ForegroundColor DarkGray

    $tools = @(
        @{Id=1; Name="VS Code"; PkgId="Microsoft.VisualStudioCode"; Desc="Editor de codigo profissional."},
        @{Id=2; Name="Git"; PkgId="Git.Git"; Desc="Sistema de controle de versao."},
        @{Id=3; Name="Windows Terminal"; PkgId="Microsoft.WindowsTerminal"; Desc="Terminal moderno com abas."},
        @{Id=4; Name="Docker Desktop"; PkgId="Docker.DockerDesktop"; Desc="Plataforma de containers."},
        @{Id=5; Name="DBeaver"; PkgId="dbeaver.dbeaver"; Desc="Gerenciador universal de Banco de Dados."},
        @{Id=6; Name="Postman"; PkgId="Postman.Postman"; Desc="Plataforma de testes de API."},
        @{Id=7; Name="PowerToys"; PkgId="Microsoft.PowerToys"; Desc="Utilitarios avancados para Windows."}
    )

    # Exibir Menu
    foreach ($t in $tools) {
        Write-Host " [$($t.Id)] $($t.Name)" -ForegroundColor Cyan -NoNewline
        Write-Host " - $($t.Desc)" -ForegroundColor DimGray
    }
    Write-Host " [A] Instalar Todas" -ForegroundColor Green
    Write-Host " [Q] Voltar ao Menu Principal`n" -ForegroundColor DarkGray

    $selection = Read-Host " Selecao"

    if ($selection -eq 'q' -or $selection -eq 'Q') { return }

    $selectedTools = @()

    if ($selection -eq 'a' -or $selection -eq 'A') {
        $selectedTools = $tools
    } else {
        $indices = $selection -split ',' | ForEach-Object { $_.Trim() }
        foreach ($idx in $indices) {
            $match = $tools | Where-Object { $_.Id -eq $idx }
            if ($match) { $selectedTools += $match }
        }
    }

    if ($selectedTools.Count -eq 0) {
        Write-Host " Nenhuma ferramenta valida selecionada." -ForegroundColor Yellow
        Start-Sleep -Seconds 1
        return
    }

    # Resumo e Confirmacao
    Write-Host "`n Voce selecionou para instalar:" -ForegroundColor Yellow
    foreach ($st in $selectedTools) {
        Write-Host "  + $($st.Name)" -ForegroundColor White
    }
    
    if (Confirm-YesNo "Confirma a instalacao destes itens?") {
        foreach ($st in $selectedTools) {
            Run-Safe -action {
                Write-Progress -Activity "Instalando DevTools" -Status "Instalando $($st.Name)..."
                winget install --id $st.PkgId -e --silent --accept-package-agreements --accept-source-agreements
            } -description "Instalar $($st.Name)"
        }
        Write-Progress -Activity "Instalando DevTools" -Completed
        Log-Success "Instalacao de DevTools concluida."
    }
}
