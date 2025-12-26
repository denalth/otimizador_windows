# Autoria: @denalth
# bloatwares.ps1 - VERSAO SUPREMA 2.1
# Remove aplicativos pre-instalados do Windows 11.

function Remove-Bloatwares-Interactive {
    Log-Info "=== REMOCAO DE BLOATWARES ==="

    Write-Host "`n O que sao Bloatwares?" -ForegroundColor Yellow
    Write-Host " Sao aplicativos pre-instalados pelo Windows que voce provavelmente" -ForegroundColor Gray
    Write-Host " nao usa e que ocupam espaco e consomem recursos em segundo plano." -ForegroundColor Gray
    Write-Host " Exemplos: Xbox, Bing Weather, Cortana, Solitaire, Maps, etc.`n" -ForegroundColor Gray

    Write-Host " Escolha uma opcao:" -ForegroundColor Cyan
    Write-Host " [A] Remocao em Massa (remove todos de uma vez)"
    Write-Host " [I] Remocao Individual (confirmar um a um)"
    Write-Host " [Q] Voltar ao Menu Principal`n" -ForegroundColor DarkGray

    $opt = Read-Host " Opcao"
    if ($opt -eq 'q' -or $opt -eq 'Q') { return }

    $apps = @(
        @{Name = "Bing/Clima/Noticias"; Pattern = "*bing*"; Desc = "Apps de noticias, clima e pesquisa Bing."},
        @{Name = "Cortana"; Pattern = "*cortana*"; Desc = "Assistente virtual da Microsoft."},
        @{Name = "Xbox/GameBar"; Pattern = "*xbox*"; Desc = "Aplicativos Xbox e gravacao de tela."},
        @{Name = "Solitaire/Jogos"; Pattern = "*solitaire*"; Desc = "Jogos de cartas pre-instalados."},
        @{Name = "Maps/Mapas"; Pattern = "*maps*"; Desc = "Aplicativo de mapas offline."},
        @{Name = "Feedback Hub"; Pattern = "*feedback*"; Desc = "Canal de feedback para a Microsoft."},
        @{Name = "Your Phone"; Pattern = "*yourphone*"; Desc = "Vinculacao com celular Android/iOS."},
        @{Name = "Clipchamp"; Pattern = "*clipchamp*"; Desc = "Editor de video da Microsoft."},
        @{Name = "Spotify"; Pattern = "*spotify*"; Desc = "Atalho pre-instalado do Spotify."},
        @{Name = "WebExperience"; Pattern = "*webexperience*"; Desc = "Widgets e noticias no desktop."}
    )

    if ($opt -eq 'a' -or $opt -eq 'A') {
        Write-Host "`n [AVISO] Esta acao ira remover TODOS os bloatwares listados acima." -ForegroundColor Red
        Write-Host " Isso libera espaco e recursos, mas alguns apps nao poderao ser reinstalados facilmente.`n" -ForegroundColor Yellow
        if (Confirm-YesNo "Confirmar remocao em massa?") {
            foreach ($app in $apps) {
                Log-Info "Removendo: $($app.Name)"
                Get-AppxPackage -AllUsers $app.Pattern | Remove-AppxPackage -ErrorAction SilentlyContinue
                Get-AppxProvisionedPackage -Online | Where-Object { $_.DisplayName -like $app.Pattern } | Remove-AppxProvisionedPackage -Online -ErrorAction SilentlyContinue
            }
            Log-Success "Remocao em massa concluida."
        }
    }
    elseif ($opt -eq 'i' -or $opt -eq 'I') {
        foreach ($app in $apps) {
            Write-Host "`n [$($app.Name)]" -ForegroundColor Cyan
            Write-Host " $($app.Desc)" -ForegroundColor Gray
            Write-Host " Acao: Este app sera desinstalado do sistema e de todos os usuarios.`n" -ForegroundColor Yellow
            if (Confirm-YesNo "Remover $($app.Name)?") {
                Get-AppxPackage -AllUsers $app.Pattern | Remove-AppxPackage -ErrorAction SilentlyContinue
                Log-Success "$($app.Name) removido."
            } else {
                Log-Info "$($app.Name) mantido."
            }
        }
    }
}

