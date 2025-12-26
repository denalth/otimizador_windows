# sdks.ps1 - VERSÃƒO SUPREMA DEFINITIVA
# InstalaÃ§Ã£o de SDKs e runtimes via winget.

function Install-SDKs-Interactive {
    Log-Info "=== INSTALAÃ‡ÃƒO DE SDKs E LINGUAGENS ==="

    if (-not (Test-WingetAvailable)) {
        Log-Error "winget nÃ£o encontrado."
        return
    }

    $sdks = @(
        # JavaScript/TypeScript
        @{Id = "OpenJS.NodeJS.LTS"; Name = "Node.js LTS"; Category = "JavaScript"},
        @{Id = "DenoLand.Deno"; Name = "Deno"; Category = "JavaScript"},
        @{Id = "oven-sh.bun"; Name = "Bun"; Category = "JavaScript"},
        
        # Python
        @{Id = "Python.Python.3.12"; Name = "Python 3.12"; Category = "Python"},
        @{Id = "Anaconda.Anaconda3"; Name = "Anaconda"; Category = "Python"},
        
        # .NET
        @{Id = "Microsoft.DotNet.SDK.8"; Name = ".NET SDK 8"; Category = ".NET"},
        @{Id = "Microsoft.DotNet.SDK.9"; Name = ".NET SDK 9"; Category = ".NET"},
        
        # Java
        @{Id = "EclipseAdoptium.Temurin.21.JDK"; Name = "Java 21 (Temurin)"; Category = "Java"},
        @{Id = "Oracle.JDK.21"; Name = "Java 21 (Oracle)"; Category = "Java"},
        @{Id = "Apache.Maven"; Name = "Maven"; Category = "Java"},
        @{Id = "Gradle.Gradle"; Name = "Gradle"; Category = "Java"},
        
        # Go
        @{Id = "GoLang.Go"; Name = "Go"; Category = "Go"},
        
        # Rust
        @{Id = "Rustlang.Rustup"; Name = "Rust (rustup)"; Category = "Rust"},
        
        # C/C++
        @{Id = "LLVM.LLVM"; Name = "LLVM/Clang"; Category = "C/C++"},
        @{Id = "Kitware.CMake"; Name = "CMake"; Category = "C/C++"},
        
        # PHP
        @{Id = "PHP.PHP"; Name = "PHP"; Category = "PHP"},
        @{Id = "Composer.Composer"; Name = "Composer"; Category = "PHP"},
        
        # Ruby
        @{Id = "RubyInstallerTeam.Ruby.3.2"; Name = "Ruby 3.2"; Category = "Ruby"}
    )

    # Agrupar por categoria
    $categories = $sdks | Group-Object -Property Category

    foreach ($cat in $categories) {
        Write-Host "`n=== $($cat.Name) ===" -ForegroundColor Cyan
        
        foreach ($sdk in $cat.Group) {
            $installed = winget list --id $sdk.Id 2>$null | Select-String $sdk.Id
            $status = if ($installed) { "[INSTALADO]" } else { "" }
            
            Write-Host "  $($sdk.Name) $status" -ForegroundColor $(if ($installed) { "DarkGray" } else { "White" })
            
            if (-not $installed -and (Confirm-YesNo "Instalar $($sdk.Name)?")) {
                Run-Safe -action { 
                    winget install --id $sdk.Id -e --silent --accept-package-agreements --accept-source-agreements
                } -description "Instalar $($sdk.Name)"
            }
        }
    }

    Log-Success "InstalaÃ§Ã£o de SDKs concluÃ­da."
    Write-Host "`n[!] Reinicie o terminal para atualizar variÃ¡veis de ambiente (PATH)." -ForegroundColor Yellow
}

function Install-WebDevStack {
    Log-Info "Instalando stack de desenvolvimento web (Node, Python, Git)..."
    
    $stack = @("OpenJS.NodeJS.LTS", "Python.Python.3.12", "Git.Git")
    
    foreach ($id in $stack) {
        Run-Safe -action { 
            winget install --id $id -e --silent --accept-package-agreements --accept-source-agreements
        } -description "Instalar $id"
    }
}



