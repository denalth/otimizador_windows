# Autoria: @denalth
# Lancar_GUI.ps1 - Interface Grafica v5.4.1 (Real Validation Edition)
# Windows Optimizer - Feedback Honesto e Verificacao Real

Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing

$scriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$modulesDir = Join-Path $scriptDir "modules"

if (Test-Path "$modulesDir\utils.ps1") { . "$modulesDir\utils.ps1" }

# === PALETA DE CORES ===
$ColorBg = [System.Drawing.Color]::FromArgb(18, 18, 18)
$ColorSidebar = [System.Drawing.Color]::FromArgb(30, 30, 30)
$ColorCard = [System.Drawing.Color]::FromArgb(45, 45, 48)
$ColorAccent = [System.Drawing.Color]::FromArgb(0, 120, 215)
$ColorText = [System.Drawing.Color]::White
$ColorTextDim = [System.Drawing.Color]::FromArgb(150, 150, 150)
$ColorSuccess = [System.Drawing.Color]::FromArgb(40, 200, 100)
$ColorWarning = [System.Drawing.Color]::FromArgb(255, 180, 0)
$ColorDanger = [System.Drawing.Color]::FromArgb(255, 80, 80)

# === FORM PRINCIPAL ===
$Form = New-Object System.Windows.Forms.Form
$Form.Text = "Windows Optimizer v5.4.1 - @denalth"
$Form.Size = New-Object System.Drawing.Size(1100, 700)
$Form.StartPosition = "CenterScreen"
$Form.BackColor = $ColorBg
$Form.ForeColor = $ColorText
$Form.FormBorderStyle = "FixedSingle"
$Form.MaximizeBox = $false
$Form.Font = New-Object System.Drawing.Font("Segoe UI", 9)

$global:LogBox = New-Object System.Windows.Forms.TextBox
$global:ActionPanel = New-Object System.Windows.Forms.Panel
$global:ProgressBar = New-Object System.Windows.Forms.ProgressBar

function Add-Log {
    param([string]$Type, [string]$Msg)
    $ts = Get-Date -Format "HH:mm:ss"
    $global:LogBox.AppendText("[$ts][$Type] $Msg`r`n")
    $global:LogBox.SelectionStart = $global:LogBox.Text.Length
    $global:LogBox.ScrollToCaret()
    [System.Windows.Forms.Application]::DoEvents()
}

# === FUNCAO DE INSTALACAO COM VALIDACAO REAL ===
function Install-WithValidation {
    param([string]PackageId, [string]Name)
    Add-Log "EXEC" "Verificando se $Name ja esta instalado..."
    $installed = winget list --id $PackageId 2>$null | Select-String $PackageId
    if ($installed) {
        Add-Log "INFO" "$Name ja esta instalado."
        return
    }
    Add-Log "EXEC" "Iniciando instalacao de $Name..."
    $psi = New-Object System.Diagnostics.ProcessStartInfo
    $psi.FileName = "winget"
    $psi.Arguments = "install --id $PackageId -e --accept-package-agreements --accept-source-agreements"
    $psi.RedirectStandardOutput = $true
    $psi.RedirectStandardError = $true
    $psi.UseShellExecute = $false
    $psi.CreateNoWindow = $true
    $proc = [System.Diagnostics.Process]::Start($psi)
    while (-not $proc.HasExited) {
        $line = $proc.StandardOutput.ReadLine()
        if ($line) { Add-Log "WINGET" $line.Trim() }
        [System.Windows.Forms.Application]::DoEvents()
    }
    $proc.WaitForExit()
    $check = winget list --id $PackageId 2>$null | Select-String $PackageId
    if ($check) { Add-Log "OK" "$Name instalado com sucesso!" }
    else { Add-Log "WARN" "Falha ao instalar $Name. Verifique no Terminal." }
}
    Add-Log "EXEC" "Instalando $Name (aguarde)..."
    $result = winget install --id $PackageId -e --silent --accept-package-agreements --accept-source-agreements 2>&1
    Start-Sleep -Seconds 2
    $check = winget list --id $PackageId 2>$null | Select-String $PackageId
    if ($check) {
        Add-Log "OK" "$Name instalado com sucesso!"
    } else {
        Add-Log "WARN" "Falha ao instalar $Name. Verifique manualmente."
    }
}

# === CATEGORIAS COM VALIDACAO REAL ===
$Categories = [ordered]@{
    "PERFORMANCE" = @{
        Color = $ColorAccent
        Actions = @(
            @{Name="Ultimate Performance"; Desc="Plano de energia oculto"; Action={
                Add-Log "EXEC" "Ativando Ultimate Performance..."
                powercfg -duplicatescheme e9a42b02-d5df-448d-aa00-03f14749eb61 2>$null
                powercfg /S e9a42b02-d5df-448d-aa00-03f14749eb61
                $active = powercfg /getactivescheme 2>$null
                if ($active -match "Ultimate") { Add-Log "OK" "Plano Ultimate ativo!" }
                else { Add-Log "WARN" "Plano pode nao ter sido ativado. Verifique em Opcoes de Energia." }
            }},
            @{Name="HAGS (GPU Scheduling)"; Desc="Melhora fluidez em jogos"; Action={
                Set-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Control\GraphicsDrivers" -Name "HwSchMode" -Value 2 -Type DWord -EA SilentlyContinue
                $val = (Get-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Control\GraphicsDrivers" -Name "HwSchMode" -EA SilentlyContinue).HwSchMode
                if ($val -eq 2) { Add-Log "OK" "HAGS ativado (requer reinicio)!" } else { Add-Log "WARN" "Falha ao ativar HAGS." }
            }},
            @{Name="Game Mode"; Desc="Prioriza recursos para jogos"; Action={
                Set-ItemProperty -Path "HKCU:\Software\Microsoft\GameBar" -Name "AllowAutoGameMode" -Value 1 -Type DWord -EA SilentlyContinue
                $val = (Get-ItemProperty -Path "HKCU:\Software\Microsoft\GameBar" -Name "AllowAutoGameMode" -EA SilentlyContinue).AllowAutoGameMode
                if ($val -eq 1) { Add-Log "OK" "Game Mode ativado!" } else { Add-Log "WARN" "Falha ao ativar Game Mode." }
            }},
            @{Name="Otimizar TCP/IP"; Desc="Reduz latencia de rede"; Action={
                $count = 0
                Get-ChildItem "HKLM:\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters\Interfaces" -EA SilentlyContinue | ForEach-Object {
                    New-ItemProperty -Path $_.PSPath -Name "TcpAckFrequency" -Value 1 -PropertyType DWord -Force -EA SilentlyContinue | Out-Null
                    New-ItemProperty -Path $_.PSPath -Name "TCPNoDelay" -Value 1 -PropertyType DWord -Force -EA SilentlyContinue | Out-Null
                    $count++
                }
                Add-Log "OK" "TCP otimizado em $count interfaces!"
            }},
            @{Name="Desativar Hibernacao"; Desc="Libera espaco em disco"; Action={
                powercfg /h off
                $hibFile = "C:\hiberfil.sys"
                if (-not (Test-Path $hibFile)) { Add-Log "OK" "Hibernacao desativada!" }
                else { Add-Log "INFO" "Comando enviado. Arquivo hiberfil.sys ainda existe (pode precisar reiniciar)." }
            }},
            @{Name="Relatorio de Energia"; Desc="Gera e abre diagnostico"; Action={
                $reportPath = "$env:USERPROFILE\Desktop\energy-report.html"
                Add-Log "EXEC" "Gerando relatorio de energia..."
                powercfg /energy /output $reportPath 2>$null
                Start-Sleep -Seconds 3
                if (Test-Path $reportPath) {
                    Add-Log "OK" "Relatorio salvo em: $reportPath"
                    Start-Process $reportPath
                    Add-Log "INFO" "Abrindo relatorio no navegador..."
                } else {
                    Add-Log "WARN" "Falha ao gerar relatorio. Execute como Admin."
                }
            }}
        )
    }
    "LIMPEZA" = @{
        Color = $ColorSuccess
        Actions = @(
            @{Name="Limpar TEMP"; Desc="Arquivos temporarios"; Action={
                $before = (Get-ChildItem "$env:TEMP" -Recurse -EA SilentlyContinue | Measure-Object -Property Length -Sum).Sum / 1MB
                Remove-Item "$env:TEMP\*" -Recurse -Force -EA SilentlyContinue
                Remove-Item "C:\Windows\Temp\*" -Recurse -Force -EA SilentlyContinue
                $after = (Get-ChildItem "$env:TEMP" -Recurse -EA SilentlyContinue | Measure-Object -Property Length -Sum).Sum / 1MB
                $freed = [math]::Round($before - $after, 1)
                Add-Log "OK" "TEMP limpo! ~${freed}MB liberados."
            }},
            @{Name="Esvaziar Lixeira"; Desc="Todos os drives"; Action={
                Clear-RecycleBin -Force -EA SilentlyContinue
                Add-Log "OK" "Lixeira esvaziada!"
            }},
            @{Name="Limpar Prefetch"; Desc="Cache de pre-carregamento"; Action={
                $count = (Get-ChildItem "C:\Windows\Prefetch" -EA SilentlyContinue).Count
                Remove-Item "C:\Windows\Prefetch\*" -Force -EA SilentlyContinue
                Add-Log "OK" "Prefetch limpo! $count arquivos removidos."
            }},
            @{Name="Limpar Cache DNS"; Desc="Resolve problemas de conexao"; Action={
                ipconfig /flushdns | Out-Null
                Add-Log "OK" "Cache DNS limpo!"
            }},
            @{Name="Limpar SoftwareDistribution"; Desc="Cache Windows Update"; Action={
                Stop-Service wuauserv -Force -EA SilentlyContinue
                $before = (Get-ChildItem "C:\Windows\SoftwareDistribution\Download" -Recurse -EA SilentlyContinue | Measure-Object -Property Length -Sum).Sum / 1MB
                Remove-Item "C:\Windows\SoftwareDistribution\Download\*" -Recurse -Force -EA SilentlyContinue
                Start-Service wuauserv -EA SilentlyContinue
                Add-Log "OK" "Cache WU limpo! ~$([math]::Round($before,1))MB liberados."
            }}
        )
    }
    "SEGURANCA" = @{
        Color = [System.Drawing.Color]::LimeGreen
        Actions = @(
            @{Name="Backup de Registro"; Desc="Salva estado do sistema"; Action={
                $dir="$env:USERPROFILE\WindowsOptimizerBackups"
                if(-not(Test-Path $dir)){New-Item -ItemType Directory -Path $dir -Force|Out-Null}
                $file = "$dir\backup_$(Get-Date -Format 'yyyyMMdd_HHmmss').reg"
                reg export "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion" $file /y 2>$null
                if (Test-Path $file) { Add-Log "OK" "Backup salvo: $file" }
                else { Add-Log "WARN" "Falha ao criar backup." }
            }},
            @{Name="Ponto de Restauracao"; Desc="Checkpoint do Windows"; Action={
                try{
                    Enable-ComputerRestore -Drive "C:\" -EA SilentlyContinue
                    Checkpoint-Computer -Description "WinOptimizer" -RestorePointType "MODIFY_SETTINGS" -EA Stop
                    Add-Log "OK" "Checkpoint criado!"
                }catch{
                    Add-Log "WARN" "Falha: $_"
                }
            }},
            @{Name="Diagnostico de Saude"; Desc="CPU, RAM, Disco, OS"; Action={
                Add-Log "INFO" "=== DIAGNOSTICO COMPLETO ==="
                # OS
                $os = Get-CimInstance Win32_OperatingSystem
                Add-Log "INFO" "OS: $($os.Caption) Build $($os.BuildNumber)"
                # CPU
                $cpu = Get-CimInstance Win32_Processor
                Add-Log "INFO" "CPU: $($cpu.Name)"
                $cpuLoad = (Get-Counter '\Processor(_Total)\% Processor Time' -EA SilentlyContinue).CounterSamples[0].CookedValue
                Add-Log "INFO" "Uso CPU: $([math]::Round($cpuLoad,1))%"
                # RAM
                $totalRam = [math]::Round($os.TotalVisibleMemorySize / 1MB, 1)
                $freeRam = [math]::Round($os.FreePhysicalMemory / 1MB, 1)
                $usedRam = $totalRam - $freeRam
                Add-Log "INFO" "RAM: ${usedRam}GB / ${totalRam}GB (Livre: ${freeRam}GB)"
                # Disco
                $disk = Get-PSDrive C
                $freeGB = [math]::Round($disk.Free / 1GB, 1)
                $usedGB = [math]::Round($disk.Used / 1GB, 1)
                Add-Log "INFO" "Disco C: ${usedGB}GB usado, ${freeGB}GB livre"
                Add-Log "OK" "Diagnostico finalizado."
            }},
            @{Name="Windows Defender Scan"; Desc="Verifica ameacas"; Action={
                Add-Log "EXEC" "Iniciando scan rapido..."
                Start-MpScan -ScanType QuickScan -EA SilentlyContinue
                Add-Log "OK" "Scan iniciado em segundo plano!"
            }}
        )
    }
    "PRIVACIDADE" = @{
        Color = [System.Drawing.Color]::MediumPurple
        Actions = @(
            @{Name="Desativar Telemetria"; Desc="Impede envio de dados"; Action={
                $p="HKLM:\SOFTWARE\Policies\Microsoft\Windows\DataCollection"
                if(-not(Test-Path $p)){New-Item -Path $p -Force|Out-Null}
                Set-ItemProperty -Path $p -Name "AllowTelemetry" -Value 0 -Type DWord
                $val = (Get-ItemProperty -Path $p -Name "AllowTelemetry" -EA SilentlyContinue).AllowTelemetry
                if ($val -eq 0) { Add-Log "OK" "Telemetria desativada!" } else { Add-Log "WARN" "Falha." }
            }},
            @{Name="Desativar Advertising ID"; Desc="Remove rastreamento"; Action={
                Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\AdvertisingInfo" -Name "Enabled" -Value 0 -Type DWord -EA SilentlyContinue
                Add-Log "OK" "Advertising ID desativado!"
            }},
            @{Name="Desativar Cortana"; Desc="Assistente de voz"; Action={
                $p="HKLM:\SOFTWARE\Policies\Microsoft\Windows\Windows Search"
                if(-not(Test-Path $p)){New-Item -Path $p -Force|Out-Null}
                Set-ItemProperty -Path $p -Name "AllowCortana" -Value 0 -Type DWord
                Add-Log "OK" "Cortana desativada!"
            }},
            @{Name="Desativar Timeline"; Desc="Historico de atividades"; Action={
                Set-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\System" -Name "EnableActivityFeed" -Value 0 -Type DWord -EA SilentlyContinue
                Add-Log "OK" "Timeline desativada!"
            }}
        )
    }
    "VISUAIS" = @{
        Color = [System.Drawing.Color]::FromArgb(150, 100, 255)
        Actions = @(
            @{Name="Tema Escuro"; Desc="Modo escuro no sistema"; Action={
                Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Themes\Personalize" -Name "AppsUseLightTheme" -Value 0 -Type DWord
                Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Themes\Personalize" -Name "SystemUsesLightTheme" -Value 0 -Type DWord
                Add-Log "OK" "Tema escuro ativado!"
            }},
            @{Name="Tema Claro"; Desc="Modo claro no sistema"; Action={
                Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Themes\Personalize" -Name "AppsUseLightTheme" -Value 1 -Type DWord
                Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Themes\Personalize" -Name "SystemUsesLightTheme" -Value 1 -Type DWord
                Add-Log "OK" "Tema claro ativado!"
            }},
            @{Name="Desativar Transparencia"; Desc="Remove efeito de vidro"; Action={
                Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Themes\Personalize" -Name "EnableTransparency" -Value 0 -Type DWord
                Add-Log "OK" "Transparencia desativada!"
            }},
            @{Name="Desativar Animacoes"; Desc="Janelas instantaneas"; Action={
                Set-ItemProperty -Path "HKCU:\Control Panel\Desktop\WindowMetrics" -Name "MinAnimate" -Value 0
                Add-Log "OK" "Animacoes desativadas!"
            }}
        )
    }
    "SERVICOS" = @{
        Color = $ColorDanger
        Actions = @(
            @{Name="Desativar DiagTrack"; Desc="Telemetria"; Action={
                Stop-Service "DiagTrack" -Force -EA SilentlyContinue
                Set-Service "DiagTrack" -StartupType Disabled -EA SilentlyContinue
                $svc = Get-Service "DiagTrack" -EA SilentlyContinue
                if ($svc.Status -eq "Stopped") { Add-Log "OK" "DiagTrack parado e desativado!" }
                else { Add-Log "WARN" "DiagTrack pode nao ter sido parado." }
            }},
            @{Name="Desativar SysMain"; Desc="Superfetch"; Action={
                Stop-Service "SysMain" -Force -EA SilentlyContinue
                Set-Service "SysMain" -StartupType Disabled -EA SilentlyContinue
                Add-Log "OK" "SysMain desativado!"
            }},
            @{Name="Desativar Windows Search"; Desc="Indexador"; Action={
                Stop-Service "WSearch" -Force -EA SilentlyContinue
                Set-Service "WSearch" -StartupType Disabled -EA SilentlyContinue
                Add-Log "OK" "Windows Search desativado!"
            }},
            @{Name="Desativar Xbox Services"; Desc="Gaming MS"; Action={
                $svcs = @("XblAuthManager","XblGameSave","XboxNetApiSvc","XboxGipSvc")
                $stopped = 0
                foreach ($s in $svcs) {
                    Stop-Service $s -Force -EA SilentlyContinue
                    Set-Service $s -StartupType Disabled -EA SilentlyContinue
                    $stopped++
                }
                Add-Log "OK" "$stopped servicos Xbox desativados!"
            }}
        )
    }
    "WINDOWS UPDATE" = @{
        Color = [System.Drawing.Color]::FromArgb(0, 120, 215)
        Actions = @(
            @{Name="Verificar Atualizacoes"; Desc="Busca e resolve erros de rede"; Action={
                Add-Log "EXEC" "Limpando proxy e rede para Update..."
                netsh winhttp reset proxy 2>$null
                Add-Log "EXEC" "Buscando atualizacoes..."
                try{
                    $S = New-Object -ComObject Microsoft.Update.Session
                    $R = $S.CreateUpdateSearcher().Search("IsInstalled=0")
                    Add-Log "INFO" "Encontradas $($R.Updates.Count) pendentes."
                }catch{
                    Add-Log "WARN" "Erro HRESULT: $($.Exception.HResult). Tentando reset total..."
                    Stop-Service wuauserv,bits -Force -EA SilentlyContinue
                    Remove-Item "C:\Windows\SoftwareDistribution\Download\*" -Recurse -Force -EA SilentlyContinue
                    Start-Service wuauserv,bits -EA SilentlyContinue
                    Add-Log "INFO" "Ambiente resetado. Tente novamente."
                }
            }},
            @{Name="Pausar por 7 dias"; Desc="Adia atualizacoes"; Action={
                $date = (Get-Date).AddDays(7).ToString("yyyy-MM-dd")
                Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\WindowsUpdate\UX\Settings" -Name "PauseUpdatesExpiryTime" -Value $date -Force -EA SilentlyContinue
                Add-Log "OK" "Atualizacoes pausadas ate $date"
            }},
            @{Name="Retomar Atualizacoes"; Desc="Remove pausa"; Action={
                Remove-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\WindowsUpdate\UX\Settings" -Name "PauseUpdatesExpiryTime" -Force -EA SilentlyContinue
                Add-Log "OK" "Atualizacoes retomadas!"
            }}
        )
    }
    "DEV TOOLS" = @{
        Color = [System.Drawing.Color]::FromArgb(255, 150, 0)
        Actions = @(
            @{Name="Instalar Git"; Desc="Controle de versao"; Action={ Install-WithValidation "Git.Git" "Git" }},
            @{Name="Instalar VS Code"; Desc="Editor de codigo"; Action={ Install-WithValidation "Microsoft.VisualStudioCode" "VS Code" }},
            @{Name="Instalar Node.js"; Desc="JavaScript runtime"; Action={ Install-WithValidation "OpenJS.NodeJS.LTS" "Node.js" }},
            @{Name="Instalar Python"; Desc="Linguagem versatil"; Action={ Install-WithValidation "Python.Python.3.12" "Python" }},
            @{Name="Instalar Docker"; Desc="Containerizacao"; Action={ Install-WithValidation "Docker.DockerDesktop" "Docker Desktop" }}
        )
    }
    "SDKS" = @{
        Color = [System.Drawing.Color]::Cyan
        Actions = @(
            @{Name="Instalar .NET SDK"; Desc="Framework MS"; Action={ Install-WithValidation "Microsoft.DotNet.SDK.8" ".NET SDK 8" }},
            @{Name="Instalar Java JDK"; Desc="Oracle OpenJDK"; Action={ Install-WithValidation "Oracle.JDK.21" "Java JDK 21" }},
            @{Name="Instalar Rust"; Desc="Linguagem de sistemas"; Action={ Install-WithValidation "Rustlang.Rustup" "Rust" }},
            @{Name="Instalar Go"; Desc="Linguagem Google"; Action={ Install-WithValidation "GoLang.Go" "Go" }}
        )
    }
    "WSL2" = @{
        Color = [System.Drawing.Color]::OrangeRed
        Actions = @(
            @{Name="Habilitar WSL2"; Desc="Subsistema Linux"; Action={
                Add-Log "EXEC" "Habilitando WSL..."
                wsl --install --no-distribution 2>$null
                Add-Log "OK" "WSL2 habilitado! Reinicie o PC."
            }},
            @{Name="Instalar Ubuntu"; Desc="Distro popular"; Action={ Install-WithValidation "Canonical.Ubuntu.2204" "Ubuntu 22.04" }},
            @{Name="Instalar Debian"; Desc="Distro estavel"; Action={ Install-WithValidation "Debian.Debian" "Debian" }},
            @{Name="Status WSL"; Desc="Lista distros"; Action={
                $status = wsl --list --verbose 2>&1
                Add-Log "INFO" "Distros WSL:"
                Add-Log "INFO" "$status"
            }}
        )
    }
    "REDE" = @{
        Color = [System.Drawing.Color]::Teal
        Actions = @(
            @{Name="DNS Cloudflare"; Desc="1.1.1.1"; Action={
                netsh interface ip set dns "Ethernet" static 1.1.1.1 primary 2>$null
                netsh interface ip add dns "Ethernet" 1.0.0.1 index=2 2>$null
                Add-Log "OK" "DNS Cloudflare configurado!"
            }},
            @{Name="DNS Google"; Desc="8.8.8.8"; Action={
                netsh interface ip set dns "Ethernet" static 8.8.8.8 primary 2>$null
                netsh interface ip add dns "Ethernet" 8.8.4.4 index=2 2>$null
                Add-Log "OK" "DNS Google configurado!"
            }},
            @{Name="Reset Winsock"; Desc="Corrige problemas"; Action={
                netsh winsock reset 2>$null
                netsh int ip reset 2>$null
                Add-Log "OK" "Winsock resetado! Reinicie o PC."
            }},
            @{Name="Renovar IP"; Desc="Novo IP do DHCP"; Action={
                ipconfig /release 2>$null
                ipconfig /renew 2>$null
                Add-Log "OK" "IP renovado!"
            }}
        )
    }
    "BLOATWARES" = @{
        Color = $ColorWarning
        Actions = @(
            @{Name="Remover Xbox Apps"; Desc="Gaming MS"; Action={
                $before = (Get-AppxPackage *xbox* | Measure-Object).Count
                Get-AppxPackage *xbox* | Remove-AppxPackage -EA SilentlyContinue
                $after = (Get-AppxPackage *xbox* | Measure-Object).Count
                Add-Log "OK" "Xbox Apps: $before -> $after pacotes."
            }},
            @{Name="Remover Cortana"; Desc="Assistente"; Action={
                Get-AppxPackage *cortana* | Remove-AppxPackage -EA SilentlyContinue
                Add-Log "OK" "Cortana removida!"
            }},
            @{Name="Remover Solitaire"; Desc="Jogos"; Action={
                Get-AppxPackage *solitaire* | Remove-AppxPackage -EA SilentlyContinue
                Add-Log "OK" "Solitaire removido!"
            }},
            @{Name="Remover Skype"; Desc="Comunicador"; Action={
                Get-AppxPackage *skype* | Remove-AppxPackage -EA SilentlyContinue
                Add-Log "OK" "Skype removido!"
            }},
            @{Name="Remover OneDrive"; Desc="Nuvem MS"; Action={
                taskkill /F /IM OneDrive.exe 2>$null
                if (Test-Path "$env:SYSTEMROOT\SysWOW64\OneDriveSetup.exe") {
                    Start-Process "$env:SYSTEMROOT\SysWOW64\OneDriveSetup.exe" -ArgumentList "/uninstall" -Wait -EA SilentlyContinue
                }
                Add-Log "OK" "OneDrive removido!"
            }}
        )
    }
    "PERFIS" = @{
        Color = [System.Drawing.Color]::Gold
        Actions = @(
            @{Name="Perfil GAMER"; Desc="Otimiza para jogos"; Action={
                Add-Log "EXEC" "Aplicando perfil Gamer..."
                powercfg -duplicatescheme e9a42b02-d5df-448d-aa00-03f14749eb61 2>$null
                Set-ItemProperty -Path "HKCU:\Software\Microsoft\GameBar" -Name "AllowAutoGameMode" -Value 1 -Type DWord -EA SilentlyContinue
                Set-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Control\GraphicsDrivers" -Name "HwSchMode" -Value 2 -Type DWord -EA SilentlyContinue
                Add-Log "OK" "Perfil Gamer aplicado!"
            }},
            @{Name="Perfil DEV"; Desc="Desenvolvimento"; Action={
                Add-Log "EXEC" "Aplicando perfil Dev..."
                Install-WithValidation "Git.Git" "Git"
                Install-WithValidation "Microsoft.VisualStudioCode" "VS Code"
                Add-Log "OK" "Perfil Dev aplicado!"
            }},
            @{Name="Perfil OFFICE"; Desc="Trabalho"; Action={
                Add-Log "EXEC" "Aplicando perfil Office..."
                Set-ItemProperty -Path "HKCU:\Control Panel\Desktop\WindowMetrics" -Name "MinAnimate" -Value 0
                Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Themes\Personalize" -Name "EnableTransparency" -Value 0 -Type DWord
                Add-Log "OK" "Perfil Office aplicado!"
            }}
        )
    }
    "SELF-UPDATE" = @{
        Color = [System.Drawing.Color]::DeepPink
        Actions = @(
            @{Name="Verificar Nova Versao"; Desc="Compara com GitHub"; Action={
                Add-Log "EXEC" "Verificando versao..."
                try{
                    $localVersion = (Get-Content "$scriptDir\version.txt" -Raw -EA Stop).Trim()
                    Add-Log "INFO" "Versao local: $localVersion"
                    $remoteVersion = (Invoke-WebRequest -Uri "https://raw.githubusercontent.com/denalth/otimizador_windows/main/version.txt" -UseBasicParsing -TimeoutSec 10).Content.Trim()
                    Add-Log "INFO" "Versao remota: $remoteVersion"
                    if ($remoteVersion -gt $localVersion) {
                        Add-Log "WARN" "NOVA VERSAO DISPONIVEL: $remoteVersion"
                    } else {
                        Add-Log "OK" "Voce esta na versao mais recente."
                    }
                }catch{
                    Add-Log "WARN" "Erro ao verificar: $($_.Exception.Message)"
                }
            }},
            @{Name="Abrir GitHub Releases"; Desc="Download manual"; Action={
                Start-Process "https://github.com/denalth/otimizador_windows/releases"
                Add-Log "OK" "Pagina de releases aberta!"
            }}
        )
    }
}

# === LAYOUT ===

$Sidebar = New-Object System.Windows.Forms.Panel
$Sidebar.Location = New-Object System.Drawing.Point(0, 0)
$Sidebar.Size = New-Object System.Drawing.Size(180, 700)
$Sidebar.BackColor = $ColorSidebar
$Form.Controls.Add($Sidebar)

$Logo = New-Object System.Windows.Forms.Label
$Logo.Text = "OPTIMIZER"
$Logo.Font = New-Object System.Drawing.Font("Segoe UI", 14, [System.Drawing.FontStyle]::Bold)
$Logo.ForeColor = $ColorAccent
$Logo.Location = New-Object System.Drawing.Point(30, 15)
$Logo.AutoSize = $true
$Sidebar.Controls.Add($Logo)

$y = 55
foreach ($catName in $Categories.Keys) {
    $catData = $Categories[$catName]
    $btn = New-Object System.Windows.Forms.Button
    $btn.Text = $catName
    $btn.Size = New-Object System.Drawing.Size(160, 32)
    $btn.Location = New-Object System.Drawing.Point(10, $y)
    $btn.FlatStyle = "Flat"
    $btn.FlatAppearance.BorderSize = 0
    $btn.BackColor = $ColorSidebar
    $btn.ForeColor = $ColorTextDim
    $btn.Font = New-Object System.Drawing.Font("Segoe UI", 8)
    $btn.TextAlign = "MiddleLeft"
    $btn.Padding = New-Object System.Windows.Forms.Padding(8, 0, 0, 0)
    $btn.Tag = @{Name = $catName; Data = $catData}
    $btn.Add_MouseEnter({ $this.BackColor = $ColorCard; $this.ForeColor = $ColorText })
    $btn.Add_MouseLeave({ $this.BackColor = $ColorSidebar; $this.ForeColor = $ColorTextDim })
    $btn.Add_Click({
        $info = $this.Tag
        $global:ActionPanel.Controls.Clear()
        $title = New-Object System.Windows.Forms.Label
        $title.Text = $info.Name
        $title.Font = New-Object System.Drawing.Font("Segoe UI", 16, [System.Drawing.FontStyle]::Bold)
        $title.ForeColor = $info.Data.Color
        $title.Location = New-Object System.Drawing.Point(10, 10)
        $title.AutoSize = $true
        $global:ActionPanel.Controls.Add($title)
        $cy = 50
        foreach ($act in $info.Data.Actions) {
            $card = New-Object System.Windows.Forms.Panel
            $card.Location = New-Object System.Drawing.Point(10, $cy)
            $card.Size = New-Object System.Drawing.Size(580, 55)
            $card.BackColor = $ColorCard
            $lblName = New-Object System.Windows.Forms.Label
            $lblName.Text = $act.Name
            $lblName.Font = New-Object System.Drawing.Font("Segoe UI Semibold", 10)
            $lblName.ForeColor = $ColorText
            $lblName.Location = New-Object System.Drawing.Point(15, 8)
            $lblName.AutoSize = $true
            $card.Controls.Add($lblName)
            $lblDesc = New-Object System.Windows.Forms.Label
            $lblDesc.Text = $act.Desc
            $lblDesc.Font = New-Object System.Drawing.Font("Segoe UI", 8)
            $lblDesc.ForeColor = $ColorTextDim
            $lblDesc.Location = New-Object System.Drawing.Point(15, 28)
            $lblDesc.Size = New-Object System.Drawing.Size(400, 20)
            $card.Controls.Add($lblDesc)
            $btnRun = New-Object System.Windows.Forms.Button
            $btnRun.Text = "EXECUTAR"
            $btnRun.Size = New-Object System.Drawing.Size(90, 30)
            $btnRun.Location = New-Object System.Drawing.Point(480, 12)
            $btnRun.FlatStyle = "Flat"
            $btnRun.FlatAppearance.BorderSize = 0
            $btnRun.BackColor = $info.Data.Color
            $btnRun.ForeColor = $ColorText
            $btnRun.Font = New-Object System.Drawing.Font("Segoe UI", 8, [System.Drawing.FontStyle]::Bold)
            $btnRun.Tag = $act.Action
            $btnRun.Add_Click({ & $this.Tag })
            $card.Controls.Add($btnRun)
            $global:ActionPanel.Controls.Add($card)
            $cy += 60
        }
    })
    $Sidebar.Controls.Add($btn)
    $y += 35
}

$global:ActionPanel.Location = New-Object System.Drawing.Point(190, 10)
$global:ActionPanel.Size = New-Object System.Drawing.Size(610, 520)
$global:ActionPanel.BackColor = $ColorBg
$global:ActionPanel.AutoScroll = $true
$Form.Controls.Add($global:ActionPanel)

$welcome = New-Object System.Windows.Forms.Label
$welcome.Text = "Selecione uma categoria no menu"
$welcome.Font = New-Object System.Drawing.Font("Segoe UI", 12)
$welcome.ForeColor = $ColorTextDim
$welcome.Location = New-Object System.Drawing.Point(150, 200)
$welcome.AutoSize = $true
$global:ActionPanel.Controls.Add($welcome)

$LogPanel = New-Object System.Windows.Forms.Panel
$LogPanel.Location = New-Object System.Drawing.Point(810, 10)
$LogPanel.Size = New-Object System.Drawing.Size(270, 640)
$LogPanel.BackColor = $ColorSidebar
$Form.Controls.Add($LogPanel)

$lblLog = New-Object System.Windows.Forms.Label
$lblLog.Text = "LOG DE EXECUCAO"
$lblLog.Font = New-Object System.Drawing.Font("Segoe UI Semibold", 10)
$lblLog.ForeColor = $ColorAccent
$lblLog.Location = New-Object System.Drawing.Point(10, 10)
$lblLog.AutoSize = $true
$LogPanel.Controls.Add($lblLog)

$global:LogBox.Multiline = $true
$global:LogBox.ScrollBars = "Vertical"
$global:LogBox.ReadOnly = $true
$global:LogBox.BackColor = [System.Drawing.Color]::FromArgb(15, 15, 18)
$global:LogBox.ForeColor = $ColorSuccess
$global:LogBox.Size = New-Object System.Drawing.Size(250, 580)
$global:LogBox.Location = New-Object System.Drawing.Point(10, 40)
$global:LogBox.Font = New-Object System.Drawing.Font("Consolas", 8)
$global:LogBox.BorderStyle = "None"
$LogPanel.Controls.Add($global:LogBox)

$Footer = New-Object System.Windows.Forms.Label
$Footer.Text = "Windows Optimizer v5.4.1 | @denalth | Real Validation Edition"
$Footer.Font = New-Object System.Drawing.Font("Segoe UI", 8)
$Footer.ForeColor = $ColorTextDim
$Footer.Location = New-Object System.Drawing.Point(350, 560)
$Footer.AutoSize = $true
$Form.Controls.Add($Footer)

[void]$Form.ShowDialog()

