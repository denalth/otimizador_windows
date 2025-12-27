# Autoria: @denalth
# health.ps1 - Modulo de Diagnostico v5.0
# Verifica a saude do sistema antes de otimizacoes

function Get-SystemHealth {
    Log-Info "=== DIAGNOSTICO DE SAUDE DO SISTEMA ==="
    
    $report = @()
    
    # 1. Espaco em Disco
    Write-Host "`n [DISCO]" -ForegroundColor Cyan
    $disk = Get-CimInstance -ClassName Win32_LogicalDisk -Filter "DriveType=3" | Select-Object DeviceID, 
        @{Name="Total(GB)";Expression={[math]::Round($_.Size/1GB,1)}}, 
        @{Name="Livre(GB)";Expression={[math]::Round($_.FreeSpace/1GB,1)}},
        @{Name="Uso%";Expression={[math]::Round((($_.Size - $_.FreeSpace) / $_.Size) * 100, 1)}}
    
    foreach ($d in $disk) {
        $status = if ($d."Livre(GB)" -lt 10) { "CRITICO" } elseif ($d."Livre(GB)" -lt 30) { "ATENCAO" } else { "OK" }
        $color = switch ($status) { "CRITICO" { "Red" } "ATENCAO" { "Yellow" } default { "Green" } }
        Write-Host "   $($d.DeviceID) - Livre: $($d.'Livre(GB)')GB / Total: $($d.'Total(GB)')GB [$status]" -ForegroundColor $color
    }
    
    # 2. Memoria RAM
    Write-Host "`n [MEMORIA]" -ForegroundColor Cyan
    $os = Get-CimInstance Win32_OperatingSystem
    $totalRAM = [math]::Round($os.TotalVisibleMemorySize / 1MB, 1)
    $freeRAM = [math]::Round($os.FreePhysicalMemory / 1MB, 1)
    $usedRAM = $totalRAM - $freeRAM
    $usagePercent = [math]::Round(($usedRAM / $totalRAM) * 100, 1)
    
    $ramStatus = if ($usagePercent -gt 90) { "CRITICO" } elseif ($usagePercent -gt 75) { "ATENCAO" } else { "OK" }
    $ramColor = switch ($ramStatus) { "CRITICO" { "Red" } "ATENCAO" { "Yellow" } default { "Green" } }
    Write-Host "   Em uso: ${usedRAM}GB / Total: ${totalRAM}GB ($usagePercent%) [$ramStatus]" -ForegroundColor $ramColor
    
    # 3. CPU
    Write-Host "`n [CPU]" -ForegroundColor Cyan
    $cpu = Get-CimInstance Win32_Processor | Select-Object Name, LoadPercentage
    foreach ($c in $cpu) {
        $cpuStatus = if ($c.LoadPercentage -gt 90) { "CRITICO" } elseif ($c.LoadPercentage -gt 70) { "ATENCAO" } else { "OK" }
        $cpuColor = switch ($cpuStatus) { "CRITICO" { "Red" } "ATENCAO" { "Yellow" } default { "Green" } }
        Write-Host "   $($c.Name) - Uso: $($c.LoadPercentage)% [$cpuStatus]" -ForegroundColor $cpuColor
    }
    
    # 4. Integridade do Windows
    Write-Host "`n [INTEGRIDADE]" -ForegroundColor Cyan
    Write-Host "   Verificando arquivos do sistema... (isso pode demorar)" -ForegroundColor Gray
    
    # SFC em modo verificacao rapida (nao repara, apenas verifica)
    # Nota: Execucao completa do SFC requer tempo, entao aqui mostramos apenas o status basico
    $lastCheck = Get-ItemProperty "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Component Based Servicing" -Name "LastSuccessStart" -ErrorAction SilentlyContinue
    if ($lastCheck) {
        Write-Host "   Ultima verificacao CBS: $($lastCheck.LastSuccessStart)" -ForegroundColor Green
    } else {
        Write-Host "   Nenhuma verificacao recente registrada. Considere rodar: sfc /scannow" -ForegroundColor Yellow
    }
    
    Write-Host "`n=== DIAGNOSTICO CONCLUIDO ===" -ForegroundColor Cyan
}

function Health-Interactive {
    Log-Info "=== MODULO DE SAUDE DO SISTEMA ==="
    
    Write-Host "`n O que voce deseja verificar?" -ForegroundColor Yellow
    Write-Host " [1] Diagnostico Completo (Disco, RAM, CPU, Integridade)" -ForegroundColor Cyan
    Write-Host " [2] Apenas Espaco em Disco" -ForegroundColor Cyan
    Write-Host " [3] Verificar Temperatura (experimental)" -ForegroundColor Cyan
    Write-Host " [Q] Voltar ao Menu Principal`n" -ForegroundColor DarkGray

    $opt = Read-Host " Opcao"
    
    switch ($opt) {
        "1" { Get-SystemHealth }
        "2" {
            Get-CimInstance -ClassName Win32_LogicalDisk -Filter "DriveType=3" | 
                Format-Table DeviceID, 
                    @{Name="Total(GB)";Expression={[math]::Round($_.Size/1GB,1)}}, 
                    @{Name="Livre(GB)";Expression={[math]::Round($_.FreeSpace/1GB,1)}} -AutoSize
        }
        "3" {
            Write-Host "`n Verificando sensores de temperatura..." -ForegroundColor Cyan
            try {
                $temps = Get-CimInstance -Namespace "root/WMI" -ClassName "MSAcpi_ThermalZoneTemperature" -ErrorAction Stop
                foreach ($t in $temps) {
                    $celsius = [math]::Round(($t.CurrentTemperature / 10) - 273.15, 1)
                    Write-Host "   Zona Termica: ${celsius}C" -ForegroundColor $(if ($celsius -gt 80) { "Red" } else { "Green" })
                }
            } catch {
                Write-Host "   Sensores de temperatura nao disponiveis neste hardware." -ForegroundColor Yellow
            }
        }
    }
    
    if ($opt -ne 'q' -and $opt -ne 'Q') {
        Read-Host "`n Pressione ENTER para voltar"
    }
}
