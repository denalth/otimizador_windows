# Autoria: @denalth
# cleanup.ps1 - VERSAO SUPREMA 2.1
# Limpeza profunda do sistema.

function System-Cleanup-Interactive {
    Log-Info "=== LIMPEZA PROFUNDA DO SISTEMA ==="

    Write-Host "`n O que essa limpeza faz?" -ForegroundColor Yellow
    Write-Host " Remove arquivos temporarios, caches, logs antigos e lixo do sistema." -ForegroundColor Gray
    Write-Host " Libera espaco em disco e pode melhorar a performance geral.`n" -ForegroundColor Gray

    Write-Host " [Q] Voltar ao Menu Principal`n" -ForegroundColor DarkGray
    $check = Read-Host " Pressione ENTER para continuar ou Q para voltar"
    if ($check -eq 'q' -or $check -eq 'Q') { return }

    # Temps
    Write-Host "`n [ACAO] Limpar Pastas Temporarias" -ForegroundColor Cyan
    Write-Host " O que vai acontecer: Arquivos em TEMP do usuario e do Windows serao removidos." -ForegroundColor Yellow
    Write-Host " Isso e seguro e pode liberar varios GBs.`n" -ForegroundColor Gray
    if (Confirm-YesNo "Limpar pastas temporarias?") {
        Run-Safe -action {
            Remove-Item "$env:LOCALAPPDATA\Temp\*" -Recurse -Force -ErrorAction SilentlyContinue
            Remove-Item "$env:TEMP\*" -Recurse -Force -ErrorAction SilentlyContinue
            Remove-Item "C:\Windows\Temp\*" -Recurse -Force -ErrorAction SilentlyContinue
        } -description "Limpeza de Temps"
    }

    # CleanMgr
    Write-Host "`n [ACAO] Limpeza de Disco Automatizada (CleanMgr)" -ForegroundColor Cyan
    Write-Host " O que vai acontecer: A ferramenta nativa de limpeza do Windows sera executada" -ForegroundColor Yellow
    Write-Host " com configuracoes pre-definidas para limpar o maximo possivel.`n" -ForegroundColor Gray
    if (Confirm-YesNo "Executar limpeza de disco automatizada?") {
        Run-Safe -action {
            $RegKeys = @(
                "Temporary Setup Files", "Active Setup Temp Folders", "Downloaded Program Files",
                "Recycle Bin", "Temporary Files", "Thumbnails", "Update Cleanup"
            )
            foreach ($Key in $RegKeys) {
                $Path = "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\VolumeCaches\$Key"
                if (Test-Path $Path) {
                    Set-ItemProperty -Path $Path -Name "StateFlags0001" -Value 2 -Type DWord -Force -ErrorAction SilentlyContinue
                }
            }
        } -description "Configurar StateFlags"
        Log-Info "Iniciando CleanMgr (pode demorar)..."
        cleanmgr /sagerun:1
    }

    Log-Success "Limpeza finalizada."
}

