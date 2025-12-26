# Autoria: @denalth
# profiles.ps1 - VERSAO SUPREMA 2.2
# Módulo de Perfis de Otimização Sugeridos.

function Profiles-Interactive {
    Log-Info "=== PERFIS DE OTIMIZACAO SUGERIDOS ==="

    Write-Host "`n O que sao Perfis?" -ForegroundColor Yellow
    Write-Host " Sao combinacoes pre-definidas de configuracoes para cenarios especificos." -ForegroundColor Gray
    Write-Host " [NOVO] Agora voce pode usar a Interface Grafica Moderna para selecionar!`n" -ForegroundColor Cyan

    Write-Host " Como deseja selecionar o perfil?" -ForegroundColor White
    Write-Host " [G] Interface Grafica (Supreme GUI)" -ForegroundColor Cyan
    Write-Host " [T] Via Terminal (Texto)" -ForegroundColor Yellow
    Write-Host " [Q] Voltar ao Menu Principal`n" -ForegroundColor DarkGray

    $mode = Read-Host " Opcao"
    
    if ($mode -eq 'q' -or $mode -eq 'Q') { return }
    
    $opt = ""
    if ($mode -eq 'g' -or $mode -eq 'G') {
        if (Get-Command Show-SupremeGUI -ErrorAction SilentlyContinue) {
            $global:SelectedProfile = ""
            Show-SupremeGUI
            $opt = $global:SelectedProfile
        } else {
            Log-Warning "Módulo GUI não carregado. Usando Terminal."
            $mode = 't'
        }
    }

    if ($mode -eq 't' -or $mode -eq 'T') {
        Write-Host "`n Escolha o perfil ideal para voce:" -ForegroundColor Cyan
        Write-Host " [1] Modo Dev (WSL2, SDKs, Performance de Disco, Git)"
        Write-Host " [2] Modo Gamer (Baixa Latencia, HAGS, Game Mode, Sem Overlays)"
        Write-Host " [3] Modo Trabalho/Estudio (Limpeza, Privacidade, Silencio)"
        Write-Host " [0] Cancelar`n"
        $opt = Read-Host " Opcao"
    }

    if ($opt -eq "" -or $opt -eq "0") { return }

    switch ($opt) {
        "1" { 
            if (Confirm-YesNo "Aplicar configuracoes do Modo Dev?") {
                Log-Info "Iniciando Perfil DEV..."
                Write-Progress -Activity "Aplicando Perfil DEV" -Status "Instalando ferramentas..." -PercentComplete 20
                if (Get-Command Install-DevTools-Essentials -ErrorAction SilentlyContinue) { Install-DevTools-Essentials }
                Write-Progress -Activity "Aplicando Perfil DEV" -Status "Configurando WSL2..." -PercentComplete 50
                if (Get-Command Setup-WSL2-Interactive -ErrorAction SilentlyContinue) { Setup-WSL2-Interactive }
                Write-Progress -Activity "Aplicando Perfil DEV" -Status "Limpando sistema..." -PercentComplete 80
                if (Get-Command System-Cleanup-Interactive -ErrorAction SilentlyContinue) { System-Cleanup-Interactive }
                Write-Progress -Activity "Aplicando Perfil DEV" -Status "Concluido" -Completed
                Log-Success "Perfil DEV aplicado por @denalth!"
            }
        }
        "2" {
            if (Confirm-YesNo "Aplicar configuracoes do Modo Gamer?") {
                Log-Info "Iniciando Perfil GAMER..."
                Write-Progress -Activity "Aplicando Perfil GAMER" -Status "Otimizando Rede..." -PercentComplete 30
                $Interfaces = Get-ChildItem "HKLM:\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters\Interfaces"
                foreach ($Interface in $Interfaces) {
                    New-ItemProperty -Path $Interface.PSPath -Name "TcpAckFrequency" -Value 1 -PropertyType DWord -Force -ErrorAction SilentlyContinue | Out-Null
                    New-ItemProperty -Path $Interface.PSPath -Name "TCPNoDelay" -Value 1 -PropertyType DWord -Force -ErrorAction SilentlyContinue | Out-Null
                }
                Write-Progress -Activity "Aplicando Perfil GAMER" -Status "Configurando Windows..." -PercentComplete 60
                if (Get-Command Gaming-Interactive -ErrorAction SilentlyContinue) { Gaming-Interactive }
                Write-Progress -Activity "Aplicando Perfil GAMER" -Status "Ajustando Energia..." -PercentComplete 90
                $Guid = "e9a42b02-d5df-448d-aa00-03f14749eb61"
                powercfg -duplicatescheme $Guid | Out-Null
                powercfg /S $Guid
                Write-Progress -Activity "Aplicando Perfil GAMER" -Status "Concluido" -Completed
                Log-Success "Perfil GAMER aplicado por @denalth!"
            }
        }
        "3" {
            if (Confirm-YesNo "Aplicar configuracoes do Modo Trabalho/Estudio?") {
                Log-Info "Iniciando Perfil WORK..."
                Write-Progress -Activity "Aplicando Perfil WORK" -Status "Privacidade..." -PercentComplete 30
                if (Get-Command Privacy-Interactive -ErrorAction SilentlyContinue) { Privacy-Interactive }
                Write-Progress -Activity "Aplicando Perfil WORK" -Status "Limpando disco..." -PercentComplete 60
                if (Get-Command System-Cleanup-Interactive -ErrorAction SilentlyContinue) { System-Cleanup-Interactive }
                Write-Progress -Activity "Aplicando Perfil WORK" -Status "Visual/Energia..." -PercentComplete 90
                if (Get-Command Adjust-Visuals-Interactive -ErrorAction SilentlyContinue) { Adjust-Visuals-Interactive }
                Write-Progress -Activity "Aplicando Perfil WORK" -Status "Concluido" -Completed
                Log-Success "Perfil WORK aplicado por @denalth!"
            }
        }
    }
}
