# Autoria: @denalth
# sdks.ps1
# Instalacao Selecionavel de SDKs e Linguagens

function Install-SDKs-Interactive {
    Log-Info "=== SDKS E LINGUAGENS ==="

    Write-Host "`n O que e isso?" -ForegroundColor Yellow
    Write-Host " Selecione os ambientes de desenvolvimento para instalar." -ForegroundColor Gray
    Write-Host " Digite os numeros separados por virgula (ex: 1,3) ou 'A' para Todos.`n" -ForegroundColor DarkGray

    $stacks = @(
        @{Id=1; Name="Node.js (LTS)"; PkgId="OpenJS.NodeJS.LTS"; Desc="Runtime Javascript essencial."},
        @{Id=2; Name="Python 3.12"; PkgId="Python.Python.3.12"; Desc="Linguagem versatil para data science e scripts."},
        @{Id=3; Name=".NET SDK 9"; PkgId="Microsoft.DotNet.SDK.9"; Desc="Desenvolvimento moderno Microsoft."},
        @{Id=4; Name="Java JDK 21"; PkgId="Oracle.JDK.21"; Desc="Java Development Kit LTS."},
        @{Id=5; Name="Go (Golang)"; PkgId="GoLang.Go"; Desc="Linguagem performatica do Google."},
        @{Id=6; Name="Rust"; PkgId="Rustlang.Rust.MSVC"; Desc="Linguagem de sistemas segura e rapida."}
    )

    # Exibir Menu
    foreach ($s in $stacks) {
        Write-Host " [$($s.Id)] $($s.Name)" -ForegroundColor Cyan -NoNewline
        Write-Host " - $($s.Desc)" -ForegroundColor DimGray
    }
    Write-Host " [A] Instalar Todos" -ForegroundColor Green
    Write-Host " [Q] Voltar ao Menu Principal`n" -ForegroundColor DarkGray

    $selection = Read-Host " Selecao"

    if ($selection -eq 'q' -or $selection -eq 'Q') { return }

    $selectedJDKs = @()

    if ($selection -eq 'a' -or $selection -eq 'A') {
        $selectedJDKs = $stacks
    } else {
        $indices = $selection -split ',' | ForEach-Object { $_.Trim() }
        foreach ($idx in $indices) {
            $match = $stacks | Where-Object { $_.Id -eq $idx }
            if ($match) { $selectedJDKs += $match }
        }
    }

    if ($selectedJDKs.Count -eq 0) {
        Write-Host " Nenhum SDK valido selecionado." -ForegroundColor Yellow
        Start-Sleep -Seconds 1
        return
    }

    # Resumo e Confirmacao
    Write-Host "`n Voce selecionou para instalar:" -ForegroundColor Yellow
    foreach ($sdk in $selectedJDKs) {
        Write-Host "  + $($sdk.Name)" -ForegroundColor White
    }
    
    if (Confirm-YesNo "Confirma a instalacao destes itens?") {
        foreach ($sdk in $selectedJDKs) {
            Run-Safe -action {
                Write-Progress -Activity "Instalando SDKs" -Status "Instalando $($sdk.Name)..."
                winget install --id $sdk.PkgId -e --silent --accept-package-agreements --accept-source-agreements
            } -description "Instalar $($sdk.Name)"
        }
        Write-Progress -Activity "Instalando SDKs" -Completed
        Log-Success "Instalacao de SDKs concluida."
    }
}
