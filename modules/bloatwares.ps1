# Autoria: @denalth
# bloatwares.ps1
# Remocao Cirurgica de Aplicativos Pre-instalados

function Remove-Bloatwares-Interactive {
    Log-Info "=== REMOCAO DE BLOATWARES ==="

    Write-Host "`n O que sao Bloatwares?" -ForegroundColor Yellow
    Write-Host " Aplicativos que ja vem no Windows e consomem recursos." -ForegroundColor Gray
    Write-Host " Selecione quais deseja remover digitando os numeros (ex: 1,2,5).`n" -ForegroundColor DarkGray

    $apps = @(
        @{Id=1; Name="Bing & Clima"; Pattern="*bing*"; Desc="Apps de noticias e clima."},
        @{Id=2; Name="Cortana"; Pattern="*cortana*"; Desc="Antigo assistente de voz."},
        @{Id=3; Name="Xbox Game Bar"; Pattern="*xbox*"; Desc="Gravacao e overlay de jogos."},
        @{Id=4; Name="Solitaire & Jogos"; Pattern="*solitaire*"; Desc="Jogos casuais pre-instalados."},
        @{Id=5; Name="Mapas (Maps)"; Pattern="*maps*"; Desc="Mapas offline do Windows."},
        @{Id=6; Name="Feedback Hub"; Pattern="*feedback*"; Desc="Ferramenta de feedback."},
        @{Id=7; Name="Vincular Celular"; Pattern="*yourphone*"; Desc="Integracao com Android/iOS."},
        @{Id=8; Name="Clipchamp"; Pattern="*clipchamp*"; Desc="Editor de videos web."},
        @{Id=9; Name="Spotify (Atalho)"; Pattern="*spotify*"; Desc="Atalho de instalacao."},
        @{Id=10; Name="Widgets & Noticias"; Pattern="*webexperience*"; Desc="Painel de widgets da barra."}
    )

    # Exibir Menu
    foreach ($a in $apps) {
        Write-Host " [$($a.Id)] $($a.Name)" -ForegroundColor Cyan -NoNewline
        Write-Host " - $($a.Desc)" -ForegroundColor DimGray
    }
    Write-Host " [A] REMOVER TODOS (Limpeza Total)" -ForegroundColor Red
    Write-Host " [Q] Voltar ao Menu Principal`n" -ForegroundColor DarkGray

    $selection = Read-Host " Selecao"

    if ($selection -eq 'q' -or $selection -eq 'Q') { return }

    $toRemove = @()

    if ($selection -eq 'a' -or $selection -eq 'A') {
        Write-Host "`n [ALERTA] Voce escolheu remover TODOS os itens listados." -ForegroundColor Red
        if (-not (Confirm-YesNo "Tem certeza absoluta?")) { return }
        $toRemove = $apps
    } else {
        $indices = $selection -split ',' | ForEach-Object { $_.Trim() }
        foreach ($idx in $indices) {
            $match = $apps | Where-Object { $_.Id -eq $idx }
            if ($match) { $toRemove += $match }
        }
    }

    if ($toRemove.Count -eq 0) {
        Write-Host " Nenhum item valido selecionado." -ForegroundColor Yellow
        Start-Sleep -Seconds 1
        return
    }

    # Resumo
    Write-Host "`n Voce vai REMOVER permanentemente:" -ForegroundColor Red
    foreach ($target in $toRemove) {
        Write-Host "  - $($target.Name)" -ForegroundColor White
    }
    
    if (Confirm-YesNo "Confirmar remocao?") {
        foreach ($target in $toRemove) {
            Run-Safe -action {
                Write-Progress -Activity "Removendo Bloatwares" -Status "Removendo $($target.Name)..."
                Get-AppxPackage -AllUsers $target.Pattern | Remove-AppxPackage -ErrorAction SilentlyContinue 2>$null
                Get-AppxProvisionedPackage -Online | Where-Object { $_.DisplayName -like $target.Pattern } | Remove-AppxProvisionedPackage -Online -ErrorAction SilentlyContinue 2>$null
            } -description "Remover $($target.Name)"
        }
        Write-Progress -Activity "Removendo Bloatwares" -Completed
        Log-Success "Limpeza de bloatwares concluida."
    }
}
