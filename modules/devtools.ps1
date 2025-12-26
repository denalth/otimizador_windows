# devtools.ps1 - VERSÃƒO SUPREMA DEFINITIVA
# InstalaÃ§Ã£o de ferramentas de desenvolvimento via winget.

function Install-DevTools-Interactive {
    Log-Info "=== INSTALAÃ‡ÃƒO DE FERRAMENTAS DE DESENVOLVIMENTO ==="

    if (-not (Test-WingetAvailable)) {
        Log-Error "winget nÃ£o encontrado. Instale o App Installer pela Microsoft Store."
        return
    }

    $tools = @(
        @{Id = "Git.Git"; Name = "Git"; Desc = "Controle de versÃ£o"},
        @{Id = "Microsoft.VisualStudioCode"; Name = "VS Code"; Desc = "Editor de cÃ³digo"},
        @{Id = "Microsoft.WindowsTerminal"; Name = "Windows Terminal"; Desc = "Terminal moderno"},
        @{Id = "Docker.DockerDesktop"; Name = "Docker Desktop"; Desc = "Containers"},
        @{Id = "GitHub.GitHubDesktop"; Name = "GitHub Desktop"; Desc = "Cliente Git GUI"},
        @{Id = "GitHub.cli"; Name = "GitHub CLI"; Desc = "GitHub na linha de comando"},
        @{Id = "JetBrains.Toolbox"; Name = "JetBrains Toolbox"; Desc = "Gerenciador de IDEs JetBrains"},
        @{Id = "Postman.Postman"; Name = "Postman"; Desc = "Teste de APIs"},
        @{Id = "Insomnia.Insomnia"; Name = "Insomnia"; Desc = "Cliente REST alternativo"},
        @{Id = "DBBrowserForSQLite.DBBrowserForSQLite"; Name = "DB Browser SQLite"; Desc = "Visualizador SQLite"},
        @{Id = "dbeaver.dbeaver"; Name = "DBeaver"; Desc = "Cliente universal de banco de dados"},
        @{Id = "Notepad++.Notepad++"; Name = "Notepad++"; Desc = "Editor de texto avanÃ§ado"},
        @{Id = "WinSCP.WinSCP"; Name = "WinSCP"; Desc = "Cliente SFTP/SCP"},
        @{Id = "PuTTY.PuTTY"; Name = "PuTTY"; Desc = "Cliente SSH"},
        @{Id = "Yarn.Yarn"; Name = "Yarn"; Desc = "Gerenciador de pacotes JS"},
        @{Id = "pnpm.pnpm"; Name = "pnpm"; Desc = "Gerenciador de pacotes JS rÃ¡pido"}
    )

    Write-Host "`nFerramentas disponÃ­veis para instalaÃ§Ã£o:`n" -ForegroundColor Cyan

    $selected = @()

    foreach ($tool in $tools) {
        $installed = winget list --id $tool.Id 2>$null | Select-String $tool.Id
        $status = if ($installed) { "[INSTALADO]" } else { "" }
        
        Write-Host "  $($tool.Name) - $($tool.Desc) $status" -ForegroundColor $(if ($installed) { "DarkGray" } else { "White" })
        
        if (-not $installed -and (Confirm-YesNo "Instalar $($tool.Name)?")) {
            $selected += $tool
        }
    }

    if ($selected.Count -eq 0) {
        Log-Info "Nenhuma ferramenta selecionada."
        return
    }

    Write-Host "`n--- Instalando $($selected.Count) ferramenta(s) ---" -ForegroundColor Cyan

    $i = 0
    foreach ($tool in $selected) {
        $i++
        Show-Progress -Activity "Instalando DevTools" -Status "$($tool.Name) ($i/$($selected.Count))" -PercentComplete (($i / $selected.Count) * 100)
        
        Run-Safe -action { 
            winget install --id $tool.Id -e --silent --accept-package-agreements --accept-source-agreements
        } -description "Instalar $($tool.Name)"
    }

    Write-Progress -Activity "Instalando DevTools" -Completed
    Log-Success "InstalaÃ§Ã£o de ferramentas concluÃ­da."
}

function Install-DevTools-Essentials {
    Log-Info "Instalando ferramentas essenciais (Git, VS Code, Terminal)..."
    
    $essentials = @("Git.Git", "Microsoft.VisualStudioCode", "Microsoft.WindowsTerminal")
    
    foreach ($id in $essentials) {
        Run-Safe -action { 
            winget install --id $id -e --silent --accept-package-agreements --accept-source-agreements
        } -description "Instalar $id"
    }
}



