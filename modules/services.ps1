# Autoria: @denalth
# services.ps1
# Gerenciamento Selecionavel de Servicos

function Services-Interactive {
    Log-Info "=== GERENCIAMENTO DE SERVICOS ==="

    Write-Host "`n O que isso faz?" -ForegroundColor Yellow
    Write-Host " Permite desativar servicos que consomem recursos sem necessidade." -ForegroundColor Gray
    Write-Host " Selecione os servicos para desativar (ex: 1,3) ou 'A' para Todos.`n" -ForegroundColor DarkGray

    $services = @(
        @{Id=1; Name="DiagTrack"; SvcName="DiagTrack"; Desc="Telemetria e rastreamento da Microsoft."; Risk="Baixo"},
        @{Id=2; Name="SysMain"; SvcName="SysMain"; Desc="Superfetch (otimizacao de carregamento, causa uso de disco)."; Risk="Medio"},
        @{Id=3; Name="Windows Search"; SvcName="WSearch"; Desc="Indexador de arquivos para pesquisa rapida."; Risk="Medio"},
        @{Id=4; Name="Distributed Link Tracking"; SvcName="TrkWks"; Desc="Mantem vinculos entre arquivos em rede."; Risk="Baixo"},
        @{Id=5; Name="Print Spooler"; SvcName="Spooler"; Desc="Gerencia filas de impressao (se nao usa impressora)."; Risk="Consulte"},
        @{Id=6; Name="Bluetooth Support"; SvcName="bthserv"; Desc="Suporte para dispositivos Bluetooth."; Risk="Consulte"}
    )

    # Exibir Menu
    foreach ($s in $services) {
        $status = (Get-Service $s.SvcName -ErrorAction SilentlyContinue).Status
        if (-not $status) { $status = "Nao Encontrado" }
        Write-Host " [$($s.Id)] $($s.Name)" -ForegroundColor Cyan -NoNewline
        Write-Host " [$status]" -ForegroundColor Gray -NoNewline
        Write-Host " - $($s.Desc) (Risco: $($s.Risk))" -ForegroundColor DimGray
    }
    Write-Host " [A] Desativar Todos (Selecionados)" -ForegroundColor Yellow
    Write-Host " [R] Restaurar Servicos Padrao (Manual)" -ForegroundColor Green
    Write-Host " [Q] Voltar ao Menu Principal`n" -ForegroundColor DarkGray

    $selection = Read-Host " Selecao"

    if ($selection -eq 'q' -or $selection -eq 'Q') { return }
    if ($selection -eq 'r' -or $selection -eq 'R') { Restore-Services; return }

    $selectedSvcs = @()

    if ($selection -eq 'a' -or $selection -eq 'A') {
        $selectedSvcs = $services
    } else {
        $indices = $selection -split ',' | ForEach-Object { $_.Trim() }
        foreach ($idx in $indices) {
            $match = $services | Where-Object { $_.Id -eq $idx }
            if ($match) { $selectedSvcs += $match }
        }
    }

    if ($selectedSvcs.Count -eq 0) {
        Write-Host " Nenhum servico valido selecionado." -ForegroundColor Yellow
        return
    }

    # Resumo
    Write-Host "`n Voce desativara os seguintes servicos:" -ForegroundColor Red
    foreach ($svc in $selectedSvcs) {
        Write-Host "  - $($svc.Name) ($($svc.SvcName))" -ForegroundColor White
    }
    
    if (Confirm-YesNo "Confirmar desativacao?") {
        foreach ($svc in $selectedSvcs) {
            Run-Safe -action {
                Stop-Service -Name $svc.SvcName -Force -ErrorAction SilentlyContinue
                Set-Service -Name $svc.SvcName -StartupType Disabled -ErrorAction SilentlyContinue
                Log-Success "$($svc.Name) desativado."
            } -description "Desativar $($svc.Name)"
        }
    }
}

function Restore-Services {
    Log-Info "Restaurando servicos para o padrao (Automatico)..."
    $toRestore = @("DiagTrack", "SysMain", "WSearch", "TrkWks", "Spooler", "bthserv")
    foreach ($s in $toRestore) {
        Set-Service -Name $s -StartupType Automatic -ErrorAction SilentlyContinue
        Start-Service -Name $s -ErrorAction SilentlyContinue
    }
    Log-Success "Servicos restaurados."
}
