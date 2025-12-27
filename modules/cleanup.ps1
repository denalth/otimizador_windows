# Autoria: @denalth
# cleanup.ps1
# Limpeza Selecionavel do Sistema

function System-Cleanup-Interactive {
    Log-Info "=== LIMPEZA DO SISTEMA ==="

    Write-Host "`n Deseja realizar uma limpeza profunda?" -ForegroundColor Yellow
    Write-Host " Selecione as areas para limpar (ex: 1,2,5) ou 'A' para Todas.`n" -ForegroundColor Gray

    $areas = @(
        @{Id=1; Name="Temporarios (User)"; Path="$env:TEMP\*"; Desc="Arquivos temporarios da sua conta."},
        @{Id=2; Name="Temporarios (Windows)"; Path="C:\Windows\Temp\*"; Desc="Arquivos temporarios do sistema."},
        @{Id=3; Name="Prefetch"; Path="C:\Windows\Prefetch\*"; Desc="Cache de inicializacao de aplicativos."},
        @{Id=4; Name="Win Update Cache"; Path="C:\Windows\SoftwareDistribution\Download\*"; Desc="Arquivos de instalacao antigos do Windows Update."},
        @{Id=5; Name="Thumbnail Cache"; Path="$env:LOCALAPPDATA\Microsoft\Windows\Explorer\thumbcache_*.db"; Desc="Cache de miniaturas de imagens."},
        @{Id=6; Name="Lixeira"; Path="RecycleBin"; Desc="Esvazia a lixeira de todos os discos."}
    )

    # Exibir Menu
    foreach ($area in $areas) {
        Write-Host " [$($area.Id)] $($area.Name)" -ForegroundColor Cyan -NoNewline
        Write-Host " - $($area.Desc)" -ForegroundColor DimGray
    }
    Write-Host " [A] Limpar TUDO" -ForegroundColor Red
    Write-Host " [Q] Voltar ao Menu Principal`n" -ForegroundColor DarkGray

    $selection = Read-Host " Selecao"
    if ($selection -eq 'q' -or $selection -eq 'Q') { return }

    $targets = @()
    if ($selection -eq 'a' -or $selection -eq 'A') {
        $targets = $areas
    } else {
        $indices = $selection -split ',' | ForEach-Object { $_.Trim() }
        foreach ($idx in $indices) {
            $match = $areas | Where-Object { $_.Id -eq $idx }
            if ($match) { $targets += $match }
        }
    }

    if ($targets.Count -eq 0) {
        Write-Host " Nenhuma area selecionada." -ForegroundColor Yellow
        return
    }

    # Resumo
    Write-Host "`n Voce vai realizar a limpeza de:" -ForegroundColor Yellow
    foreach ($t in $targets) {
        Write-Host "  + $($t.Name)" -ForegroundColor White
    }

    if (Confirm-YesNo "Iniciar limpeza agora?") {
        foreach ($t in $targets) {
            Run-Safe -action {
                if ($t.Name -eq "Lixeira") {
                    Clear-RecycleBin -Force -ErrorAction SilentlyContinue
                } else {
                    Remove-Item -Path $t.Path -Recurse -Force -ErrorAction SilentlyContinue
                }
                Log-Success "Limpeza de $($t.Name) concluida."
            } -description "Limpar $($t.Name)"
        }
        
        # Limpeza CleanMgr Adicional
        if (Confirm-YesNo "Executar Limpeza de Disco Avançada (CleanMgr)?") {
            Log-Info "Configurando CleanMgr..."
            $Path = "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\VolumeCaches"
            $Caches = Get-ChildItem -Path $Path
            foreach ($Cache in $Caches) {
                Set-ItemProperty -Path $Cache.PSPath -Name "StateFlags0001" -Value 2 -Type DWord -Force -ErrorAction SilentlyContinue | Out-Null
            }
            Log-Info "Iniciando CleanMgr em segundo plano..."
            Start-Process "cleanmgr.exe" -ArgumentList "/sagerun:1" -WindowStyle Hidden
        }
        
        Log-Success "Rotina de limpeza finalizada."
    }
}
