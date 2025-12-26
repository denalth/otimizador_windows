# visuals.ps1 - VERSÃƒO SUPREMA DEFINITIVA
# Ajustes visuais para mÃ¡ximo desempenho.

function Adjust-Visuals-Interactive {
    Log-Info "=== AJUSTES VISUAIS ==="

    Write-Host "`nOpÃ§Ãµes para melhorar responsividade em mÃ¡quinas com recursos limitados." -ForegroundColor Yellow
    Write-Host "Recomendado para: PCs antigos, VMs, foco em performance.`n" -ForegroundColor Gray

    # 1. TransparÃªncia
    if (Confirm-YesNo "Desativar transparÃªncia do menu iniciar e barra de tarefas?") {
        Run-Safe -action {
            $path = "HKCU:\Software\Microsoft\Windows\CurrentVersion\Themes\Personalize"
            if (-not (Test-Path $path)) { New-Item -Path $path -Force | Out-Null }
            Set-ItemProperty -Path $path -Name "EnableTransparency" -Value 0 -Type DWord
        } -description "Desativar transparÃªncia"
    }

    # 2. AnimaÃ§Ãµes de janela
    if (Confirm-YesNo "Desativar animaÃ§Ãµes de minimizar/maximizar?") {
        Run-Safe -action {
            Set-ItemProperty "HKCU:\Control Panel\Desktop\WindowMetrics" "MinAnimate" "0"
        } -description "Desativar MinAnimate"
    }

    # 3. Efeitos visuais gerais
    if (Confirm-YesNo "Ajustar para 'Melhor Desempenho' (desativa maioria dos efeitos)?") {
        Run-Safe -action {
            $path = "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\VisualEffects"
            if (-not (Test-Path $path)) { New-Item -Path $path -Force | Out-Null }
            Set-ItemProperty -Path $path -Name "VisualFXSetting" -Value 2 -Type DWord
        } -description "Efeitos visuais: Melhor Desempenho"
    }

    # 4. Tema escuro
    if (Confirm-YesNo "Ativar tema escuro do sistema?") {
        Run-Safe -action {
            $path = "HKCU:\Software\Microsoft\Windows\CurrentVersion\Themes\Personalize"
            Set-ItemProperty -Path $path -Name "AppsUseLightTheme" -Value 0 -Type DWord
            Set-ItemProperty -Path $path -Name "SystemUsesLightTheme" -Value 0 -Type DWord
        } -description "Ativar tema escuro"
    }

    # 5. remocaocaover Cortana da barra de tarefas
    if (Confirm-YesNo "Ocultar botÃ£o da Cortana na barra de tarefas?") {
        Run-Safe -action {
            Set-ItemProperty "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" "ShowCortanaButton" 0
        } -description "Ocultar Cortana"
    }

    # 6. remocaocaover Widget/News
    if (Confirm-YesNo "Desativar Widgets/News na barra de tarefas?") {
        Run-Safe -action {
            $path = "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced"
            Set-ItemProperty -Path $path -Name "TaskbarDa" -Value 0 -Type DWord -ErrorAction SilentlyContinue
        } -description "Desativar Widgets"
    }

    # 7. remocaocaover Chat/Teams
    if (Confirm-YesNo "remocaocaover Ã­cone do Chat/Teams da barra de tarefas?") {
        Run-Safe -action {
            Set-ItemProperty "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" "TaskbarMn" 0
        } -description "remocaocaover Chat/Teams"
    }

    Write-Host "`n[!] Algumas alteraÃ§Ãµes requerem logout ou reinÃ­cio." -ForegroundColor Yellow
    Log-Success "Ajustes visuais aplicados."
}

function Restore-VisualEffects {
    Log-Info "Restaurando efeitos visuais padrÃ£o..."
    Run-Safe -action {
        Set-ItemProperty "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\VisualEffects" "VisualFXSetting" 0
        Set-ItemProperty "HKCU:\Software\Microsoft\Windows\CurrentVersion\Themes\Personalize" "EnableTransparency" 1
    } -description "Restaurar efeitos visuais"
}



