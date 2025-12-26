# wsl2.ps1 - VERSÃƒO SUPREMA DEFINITIVA
# ConfiguraÃ§Ã£o completa do WSL2 com opÃ§Ãµes de distro.

function Setup-WSL2-Interactive {
    Log-Info "=== CONFIGURAÃ‡ÃƒO DO WSL2 ==="

    $winVer = Get-WindowsVersion
    Write-Host "`nVersÃ£o do Windows: $($winVer.Name) (Build $($winVer.Build))" -ForegroundColor Gray

    if ([int]$winVer.Build -lt 19041) {
        Log-Error "WSL2 requer Windows 10 versÃ£o 2004+ (Build 19041+)"
        return
    }

    Write-Host "`nâ”Œâ”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€" -ForegroundColor DarkGray
    Write-Host "â”‚ WSL2 - Windows Subsystem for Linux" -ForegroundColor Cyan
    Write-Host "â”‚ Permite rodar Linux nativamente no Windows." -ForegroundColor White
    Write-Host "â”‚ Ideal para: Desenvolvimento, Docker, DevOps" -ForegroundColor Gray
    Write-Host "â”‚ Requisito: VirtualizaÃ§Ã£o habilitada na BIOS" -ForegroundColor DarkGray
    Write-Host "â””â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€" -ForegroundColor DarkGray

    if (-not (Confirm-YesNo "Deseja habilitar WSL2 e Virtual Machine Platform?")) {
        Log-Info "OperaÃ§Ã£o cancelada."
        return
    }

    # Habilitar recursos do Windows
    Log-Info "Habilitando recursos necessÃ¡rios..."
    
    Run-Safe -action { 
        dism.exe /online /enable-feature /featurename:Microsoft-Windows-Subsystem-Linux /all /norestart 
    } -description "Habilitar WSL"
    
    Run-Safe -action { 
        dism.exe /online /enable-feature /featurename:VirtualMachinePlatform /all /norestart 
    } -description "Habilitar Virtual Machine Platform"

    # Atualizar WSL
    Log-Info "Atualizando componentes do WSL..."
    Run-Safe -action { wsl --update } -description "wsl --update"
    Run-Safe -action { wsl --set-default-version 2 } -description "Definir WSL2 como padrÃ£o"

    # Escolha de distro
    Write-Host "`n--- Escolha uma DistribuiÃ§Ã£o Linux ---" -ForegroundColor Cyan
    Write-Host "1) Ubuntu (Recomendado - LTS)"
    Write-Host "2) Debian"
    Write-Host "3) Fedora Remix"
    Write-Host "4) Kali Linux"
    Write-Host "5) Alpine"
    Write-Host "0) Pular instalaÃ§Ã£o de distro"

    $choice = Read-Host "Escolha (0-5)"

    $distros = @{
        "1" = @{Id = "Canonical.Ubuntu"; Name = "Ubuntu"}
        "2" = @{Id = "Debian.Debian"; Name = "Debian"}
        "3" = @{Id = "WhitewaterFoundry.Fedora"; Name = "Fedora"}
        "4" = @{Id = "kalilinux.kalilinux"; Name = "Kali Linux"}
        "5" = @{Id = "Alpine.WSL"; Name = "Alpine"}
    }

    if ($distros.ContainsKey($choice) -and (Test-WingetAvailable)) {
        $distro = $distros[$choice]
        Run-Safe -action { 
            winget install --id $distro.Id -e --silent --accept-package-agreements --accept-source-agreements
        } -description "Instalar $($distro.Name)"
    } elseif ($choice -ne "0") {
        Log-Warning "OpÃ§Ã£o invÃ¡lida ou winget nÃ£o disponÃ­vel."
    }

    Write-Host "`n[!] IMPORTANTE: Reinicie o computador para concluir a instalaÃ§Ã£o." -ForegroundColor Yellow
    
    if (Confirm-YesNo "Reiniciar agora?") {
        Log-Info "Reiniciando..."
        Restart-Computer
    } else {
        Log-Info "Lembre-se de reiniciar antes de usar o WSL2."
    }
}

function Show-WSLStatus {
    Log-Info "Status do WSL:"
    wsl --status
    Write-Host "`nDistribuiÃ§Ãµes instaladas:" -ForegroundColor Cyan
    wsl --list --verbose
}



