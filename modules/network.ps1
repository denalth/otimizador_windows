# network.ps1 - VERSAO SUPREMA 2.1
# Otimizacoes de rede e DNS.

function Network-Interactive {
    Log-Info "=== OTIMIZACOES DE REDE ==="

    Write-Host "`n O que essas configuracoes fazem?" -ForegroundColor Yellow
    Write-Host " Otimizam a pilha de rede do Windows para menor latencia (ping)" -ForegroundColor Gray
    Write-Host " e permitem configurar DNS mais rapidos e seguros.`n" -ForegroundColor Gray

    Write-Host " [Q] Voltar ao Menu Principal`n" -ForegroundColor DarkGray
    $check = Read-Host " Pressione ENTER para continuar ou Q para voltar"
    if ($check -eq 'q' -or $check -eq 'Q') { return }

    # DNS
    Write-Host "`n [ACAO] Configurar DNS Customizado" -ForegroundColor Cyan
    Write-Host " O que vai acontecer: O servidor DNS dos seus adaptadores de rede sera alterado." -ForegroundColor Yellow
    Write-Host " DNS mais rapidos = sites carregando mais rapido.`n" -ForegroundColor Gray
    if (Confirm-YesNo "Configurar DNS?") {
        Write-Host "`n Escolha um provedor:" -ForegroundColor Cyan
        Write-Host " 1) Cloudflare (1.1.1.1) - Mais rapido"
        Write-Host " 2) Google (8.8.8.8) - Confiavel"
        Write-Host " 3) Quad9 (9.9.9.9) - Foco em seguranca"
        Write-Host " 4) AdGuard (94.140.14.14) - Bloqueia anuncios"
        Write-Host " 0) Cancelar"
        $dnsChoice = Read-Host " Escolha"
        $dnsServers = switch ($dnsChoice) {
            "1" { @("1.1.1.1", "1.0.0.1") }
            "2" { @("8.8.8.8", "8.8.4.4") }
            "3" { @("9.9.9.9", "149.112.112.112") }
            "4" { @("94.140.14.14", "94.140.15.15") }
            default { $null }
        }
        if ($dnsServers) {
            $adapters = Get-NetAdapter | Where-Object { $_.Status -eq 'Up' }
            foreach ($adapter in $adapters) {
                Run-Safe -action { Set-DnsClientServerAddress -InterfaceIndex $adapter.ifIndex -ServerAddresses $dnsServers } -description "DNS em $($adapter.Name)"
            }
        }
    }

    # TCP Tweaks
    Write-Host "`n [ACAO] Otimizar Pilha TCP (Nagle/Latencia)" -ForegroundColor Cyan
    Write-Host " O que vai acontecer: Chaves de registro serao modificadas para desativar" -ForegroundColor Yellow
    Write-Host " o algoritmo de Nagle, que agrupa pacotes e aumenta a latencia.`n" -ForegroundColor Gray
    if (Confirm-YesNo "Aplicar tweaks de TCP?") {
        Run-Safe -action {
            $Interfaces = Get-ChildItem "HKLM:\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters\Interfaces"
            foreach ($Interface in $Interfaces) {
                New-ItemProperty -Path $Interface.PSPath -Name "TcpAckFrequency" -Value 1 -PropertyType DWord -Force -ErrorAction SilentlyContinue | Out-Null
                New-ItemProperty -Path $Interface.PSPath -Name "TCPNoDelay" -Value 1 -PropertyType DWord -Force -ErrorAction SilentlyContinue | Out-Null
            }
        } -description "Otimizar Pilha TCP"
    }

    Log-Success "Configuracoes de rede aplicadas."
}
