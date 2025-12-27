# Autoria: @denalth
# visuals.ps1
# Ajustes visuais para maximo desempenho.

function Adjust-Visuals-Interactive {
    Log-Info "=== AJUSTES VISUAIS ==="

    Write-Host "`n O que estes ajustes fazem?" -ForegroundColor Yellow
    Write-Host " Desativam efeitos visuais desnecessarios (transparencia, animacoes)" -ForegroundColor Gray
    Write-Host " para tornar a interface do Windows mais rapida e responsiva.`n" -ForegroundColor Gray

    Write-Host " [Q] Voltar ao Menu Principal`n" -ForegroundColor DarkGray
    $check = Read-Host " Pressione ENTER para continuar ou Q para voltar"
    if ($check -eq 'q' -or $check -eq 'Q') { return }

    # Transparencia
    Write-Host "`n [ACAO] Desativar Transparencia" -ForegroundColor Cyan
    Write-Host " O que vai acontecer: O efeito de vidro em janelas e barra de tarefas sera removido." -ForegroundColor Yellow
    if (Confirm-YesNo "Desativar transparencia?") {
        Run-Safe -action {
            Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Themes\Personalize" -Name "EnableTransparency" -Value 0 -Type DWord
        } -description "Desativar Transparencia"
    }

    # Animacoes
    Write-Host "`n [ACAO] Desativar Animacoes do Windows" -ForegroundColor Cyan
    Write-Host " O que vai acontecer: Janelas abrirao instantaneamente sem 'deslizar'.`n" -ForegroundColor Yellow
    if (Confirm-YesNo "Desativar animacoes?") {
        Run-Safe -action {
            Set-ItemProperty -Path "HKCU:\Control Panel\Desktop" -Name "UserPreferencesMask" -Value ([byte[]](144,18,3,0,0,0,0,0)) -Type Binary
            Set-ItemProperty -Path "HKCU:\Control Panel\Desktop\WindowMetrics" -Name "MinAnimate" -Value 0
        } -description "Desativar Animacoes"
    }

    # Dark Theme
    Write-Host "`n [ACAO] Ativar Tema Escuro (Modo @denalth)" -ForegroundColor Cyan
    Write-Host " O que vai acontecer: Todo o sistema padrao usara o tema escuro.`n" -ForegroundColor Yellow
    if (Confirm-YesNo "Ativar Tema Escuro?") {
        Run-Safe -action {
            Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Themes\Personalize" -Name "AppsUseLightTheme" -Value 0 -Type DWord
            Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Themes\Personalize" -Name "SystemUsesLightTheme" -Value 0 -Type DWord
        } -description "Ativar Tema Escuro"
    }

    Log-Success "Ajustes visuais concluidos."
}
