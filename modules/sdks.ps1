# Autoria: @denalth
# sdks.ps1 - VERSAO SUPREMA 2.2
# Instalação de SDKs e linguagens via winget.

function Install-SDKs-Interactive {
    Log-Info "=== SDKS E LINGUAGENS ==="

    Write-Host "`n O que e isso?" -ForegroundColor Yellow
    Write-Host " Instalacao automatizada do ambiente de desenvolvimento (Compiladores e Runtimes).`n" -ForegroundColor Gray

    Write-Host " [Q] Voltar ao Menu Principal`n" -ForegroundColor DarkGray
    $check = Read-Host " Pressione ENTER para continuar ou Q para voltar"
    if ($check -eq 'q' -or $check -eq 'Q') { return }

    $stacks = @(
        @{Name = "Node.js (LTS)"; ID = "OpenJS.NodeJS.LTS"; Desc = "Javascript Runtime."},
        @{Name = "Python 3"; ID = "Python.Python.3.12"; Desc = "Linguagem versatil para scripts e IA."},
        @{Name = ".NET SDK 9"; ID = "Microsoft.DotNet.SDK.9"; Desc = "Desenvolvimento Microsoft."},
        @{Name = "Java JDK"; ID = "Oracle.JDK.21"; Desc = "Java Development Kit."},
        @{Name = "Go"; ID = "GoLang.Go"; Desc = "Linguagem do Google."},
        @{Name = "Rust"; ID = "Rustlang.Rust.MSVC"; Desc = "System Programming."}
    )

    foreach ($stack in $stacks) {
        Write-Host "`n [$($stack.Name)]" -ForegroundColor Cyan
        Write-Host " $($stack.Desc)" -ForegroundColor Gray
        if (Confirm-YesNo "Instalar $($stack.Name)?") {
            Run-Safe -action {
                winget install --id $stack.ID -e --silent --accept-package-agreements --accept-source-agreements
            } -description "Instalar $($stack.Name)"
        }
    }
}
