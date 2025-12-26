# Autoria: @denalth
# wsl2.ps1 - VERSAO SUPREMA 2.2
# Configuração do Subsistema Linux no Windows.

function Setup-WSL2-Interactive {
    Log-Info "=== CONFIGURACAO WSL2 ==="

    Write-Host "`n O que e o WSL2?" -ForegroundColor Yellow
    Write-Host " Permite rodar o Kernel Linux real dentro do Windows sem maquinas virtuais pesadas." -ForegroundColor Gray
    Write-Host " Essencial para desenvolvedores modernos.`n" -ForegroundColor Gray

    Write-Host " [Q] Voltar ao Menu Principal`n" -ForegroundColor DarkGray
    $check = Read-Host " Pressione ENTER para continuar ou Q para voltar"
    if ($check -eq 'q' -or $check -eq 'Q') { return }

    # Ativar Features
    Write-Host "`n [ACAO] Habilitar Recursos Necessarios" -ForegroundColor Cyan
    Write-Host " O que vai acontecer: Recursos de Virtualizacao e WSL serao ativados no Windows." -ForegroundColor Yellow
    if (Confirm-YesNo "Habilitar recursos?") {
        Run-Safe -action {
            dism.exe /online /enable-feature /featurename:Microsoft-Windows-Subsystem-Linux /all /norestart
            dism.exe /online /enable-feature /featurename:VirtualMachinePlatform /all /norestart
        } -description "Habilitar WSL/Virtualizacao"
    }

    # Instalar Ubuntu
    Write-Host "`n [ACAO] Instalar Ubuntu Distro" -ForegroundColor Cyan
    Write-Host " O que vai acontecer: A distribuicao Ubuntu sera baixada e instalada.`n" -ForegroundColor Yellow
    if (Confirm-YesNo "Instalar Ubuntu?") {
        Run-Safe -action {
            wsl --install -d Ubuntu --no-launch
        } -description "Instalar Ubuntu"
    }

    Log-Success "Processo concluido. REINICIE o computador para finalizar o WSL2."
}
