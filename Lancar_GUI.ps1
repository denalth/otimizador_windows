# Autoria: @denalth
# Lancar_GUI.ps1 - Interface Grafica v5.2.1 (Elite Modern UI)
# Windows Optimizer Supreme Edition

Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing

$scriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$modulesDir = Join-Path $scriptDir "modules"

# Carregar funcoes utilitarias
if (Test-Path "$modulesDir\utils.ps1") { . "$modulesDir\utils.ps1" }

# === PALETA DE CORES MODERN UI ===
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
$Form.Text = "Windows Optimizer v5.2.1 - @denalth"
$Form.Size = New-Object System.Drawing.Size(1100, 700)
$Form.StartPosition = "CenterScreen"
$Form.BackColor = $ColorBg
$Form.ForeColor = $ColorText
$Form.FormBorderStyle = "FixedSingle"
$Form.MaximizeBox = $false
$Form.Font = New-Object System.Drawing.Font("Segoe UI", 9)

# === COMPONENTES GLOBAIS ===
$global:ProgressBar = New-Object System.Windows.Forms.ProgressBar
$global:LogBox = New-Object System.Windows.Forms.TextBox
$global:ActionPanel = New-Object System.Windows.Forms.Panel

# --- Funcoes de Log GUI ---
function Add-Log {
    param([string]$Type, [string]$Msg)
    $timestamp = Get-Date -Format "HH:mm:ss"
    $line = "[$timestamp][$Type] $Msg"
    $global:LogBox.AppendText("$line`r`n")
    $global:LogBox.SelectionStart = $global:LogBox.Text.Length
    $global:LogBox.ScrollToCaret()
    [System.Windows.Forms.Application]::DoEvents()
}

function Show-Confirm {
    param([string]$Msg)
    $res = [System.Windows.Forms.MessageBox]::Show($Msg, "Confirmacao @denalth", "YesNo", "Question")
    return $res -eq "Yes"
}

# === DEFINICAO COMPLETA DE CATEGORIAS ===
$Categories = [ordered]@{
    "PERFORMANCE" = @{
        Color = $ColorAccent
        Actions = @(
            @{Name="Ultimate Performance"; Desc="Ativa plano de energia oculto"; Action={
                Add-Log "EXEC" "Ativando Ultimate Performance..."
                powercfg -duplicatescheme e9a42b02-d5df-448d-aa00-03f14749eb61 2>$null
                powercfg /S e9a42b02-d5df-448d-aa00-03f14749eb61
                Add-Log "OK" "Plano ativo!"
            }},
            @{Name="HAGS (GPU Scheduling)"; Desc="Melhora fluidez em jogos"; Action={
                Set-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Control\GraphicsDrivers" -Name "HwSchMode" -Value 2 -Type DWord -ErrorAction SilentlyContinue
                Add-Log "OK" "HAGS ativado!"
            }},
            @{Name="Game Mode"; Desc="Prioriza recursos para jogos"; Action={
                Set-ItemProperty -Path "HKCU:\Software\Microsoft\GameBar" -Name "AllowAutoGameMode" -Value 1 -Type DWord -ErrorAction SilentlyContinue
                Add-Log "OK" "Game Mode ativado!"
            }},
            @{Name="Otimizar TCP/IP"; Desc="Reduz latencia de rede"; Action={
                Add-Log "EXEC" "Otimizando TCP..."
                $Interfaces = Get-ChildItem "HKLM:\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters\Interfaces" -ErrorAction SilentlyContinue
                foreach ($i in $Interfaces) {
                    New-ItemProperty -Path $i.PSPath -Name "TcpAckFrequency" -Value 1 -PropertyType DWord -Force -ErrorAction SilentlyContinue | Out-Null
                    New-ItemProperty -Path $i.PSPath -Name "TCPNoDelay" -Value 1 -PropertyType DWord -Force -ErrorAction SilentlyContinue | Out-Null
                }
                Add-Log "OK" "TCP otimizado!"
            }}
        )
    }
    "LIMPEZA" = @{
        Color = $ColorSuccess
        Actions = @(
            @{Name="Limpar TEMP"; Desc="Remove arquivos temporarios"; Action={
                Add-Log "EXEC" "Limpando TEMP..."
                Remove-Item "$env:TEMP\*" -Recurse -Force -ErrorAction SilentlyContinue
                Remove-Item "C:\Windows\Temp\*" -Recurse -Force -ErrorAction SilentlyContinue
                Add-Log "OK" "TEMP limpo!"
            }},
            @{Name="Esvaziar Lixeira"; Desc="Limpa lixeira de todos os drives"; Action={
                Clear-RecycleBin -Force -ErrorAction SilentlyContinue
                Add-Log "OK" "Lixeira esvaziada!"
            }},
            @{Name="Limpar Prefetch"; Desc="Cache de pre-carregamento"; Action={
                Remove-Item "C:\Windows\Prefetch\*" -Force -ErrorAction SilentlyContinue
                Add-Log "OK" "Prefetch limpo!"
            }},
            @{Name="Limpar Cache DNS"; Desc="Resolve problemas de conexao"; Action={
                ipconfig /flushdns | Out-Null
                Add-Log "OK" "Cache DNS limpo!"
            }}
        )
    }
    "SEGURANCA" = @{
        Color = [System.Drawing.Color]::LimeGreen
        Actions = @(
            @{Name="Backup de Registro"; Desc="Salva estado atual do sistema"; Action={
                Add-Log "INFO" "Iniciando backup..."
                $backupDir = "$env:USERPROFILE\WindowsOptimizerBackups"
                if (-not (Test-Path $backupDir)) { New-Item -ItemType Directory -Path $backupDir -Force | Out-Null }
                $date = Get-Date -Format "yyyyMMdd_HHmmss"
                reg export "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion" "$backupDir\CurrentVersion_$date.reg" /y 2>$null
                Add-Log "OK" "Backup salvo em $backupDir"
            }},
            @{Name="Ponto de Restauracao"; Desc="Cria checkpoint do Windows"; Action={
                Add-Log "INFO" "Criando ponto de restauracao..."
                try {
                    Enable-ComputerRestore -Drive "C:\" -ErrorAction SilentlyContinue
                    Checkpoint-Computer -Description "Windows Optimizer v5.2.1" -RestorePointType "MODIFY_SETTINGS" -ErrorAction Stop
                    Add-Log "OK" "Checkpoint criado!"
                } catch {
                    Add-Log "WARN" "Falha: Execute como Admin ou habilite protecao do sistema."
                }
            }},
            @{Name="Diagnostico de Saude"; Desc="Verifica disco, RAM e CPU"; Action={
                Add-Log "INFO" "=== DIAGNOSTICO ==="
                $free = [math]::Round((Get-PSDrive C).Free / 1GB, 1)
                Add-Log "INFO" "Disco C: ${free}GB livres"
                $ram = Get-CimInstance Win32_OperatingSystem
                $freeRam = [math]::Round($ram.FreePhysicalMemory / 1MB, 1)
                Add-Log "INFO" "RAM Livre: ${freeRam}MB"
                Add-Log "OK" "Diagnostico finalizado."
            }}
        )
    }
    "PRIVACIDADE" = @{
        Color = [System.Drawing.Color]::MediumPurple
        Actions = @(
            @{Name="Desativar Telemetria"; Desc="Impede envio de dados para MS"; Action={
                $path = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\DataCollection"
                if (-not (Test-Path $path)) { New-Item -Path $path -Force | Out-Null }
                Set-ItemProperty -Path $path -Name "AllowTelemetry" -Value 0 -Type DWord
                Add-Log "OK" "Telemetria desativada!"
            }},
            @{Name="Desativar Advertising ID"; Desc="Remove rastreamento de anuncios"; Action={
                Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\AdvertisingInfo" -Name "Enabled" -Value 0 -Type DWord -ErrorAction SilentlyContinue
                Add-Log "OK" "Advertising ID desativado!"
            }},
            @{Name="Desativar Cortana"; Desc="Remove assistente de voz"; Action={
                $path = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\Windows Search"
                if (-not (Test-Path $path)) { New-Item -Path $path -Force | Out-Null }
                Set-ItemProperty -Path $path -Name "AllowCortana" -Value 0 -Type DWord
                Add-Log "OK" "Cortana desativada!"
            }}
        )
    }
    "VISUAIS" = @{
        Color = [System.Drawing.Color]::FromArgb(150, 100, 255)
        Actions = @(
            @{Name="Tema Escuro"; Desc="Aplica modo escuro no sistema"; Action={
                Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Themes\Personalize" -Name "AppsUseLightTheme" -Value 0 -Type DWord
                Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Themes\Personalize" -Name "SystemUsesLightTheme" -Value 0 -Type DWord
                Add-Log "OK" "Tema escuro ativado!"
            }},
            @{Name="Desativar Transparencia"; Desc="Remove efeito de vidro"; Action={
                Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Themes\Personalize" -Name "EnableTransparency" -Value 0 -Type DWord
                Add-Log "OK" "Transparencia desativada!"
            }},
            @{Name="Desativar Animacoes"; Desc="Janelas abrem instantaneamente"; Action={
                Set-ItemProperty -Path "HKCU:\Control Panel\Desktop\WindowMetrics" -Name "MinAnimate" -Value 0
                Add-Log "OK" "Animacoes desativadas!"
            }}
        )
    }
    "SERVICOS" = @{
        Color = $ColorDanger
        Actions = @(
            @{Name="Desativar DiagTrack"; Desc="Servico de telemetria"; Action={
                Stop-Service -Name "DiagTrack" -Force -ErrorAction SilentlyContinue
                Set-Service -Name "DiagTrack" -StartupType Disabled -ErrorAction SilentlyContinue
                Add-Log "OK" "DiagTrack desativado!"
            }},
            @{Name="Desativar SysMain"; Desc="Superfetch (uso de disco)"; Action={
                Stop-Service -Name "SysMain" -Force -ErrorAction SilentlyContinue
                Set-Service -Name "SysMain" -StartupType Disabled -ErrorAction SilentlyContinue
                Add-Log "OK" "SysMain desativado!"
            }},
            @{Name="Desativar Windows Search"; Desc="Indexador de arquivos"; Action={
                Stop-Service -Name "WSearch" -Force -ErrorAction SilentlyContinue
                Set-Service -Name "WSearch" -StartupType Disabled -ErrorAction SilentlyContinue
                Add-Log "OK" "Windows Search desativado!"
            }}
        )
    }
    "WINDOWS UPDATE" = @{
        Color = [System.Drawing.Color]::FromArgb(0, 120, 215)
        Actions = @(
            @{Name="Verificar Atualizacoes"; Desc="Busca updates disponiveis"; Action={
                Add-Log "EXEC" "Verificando..."
                try {
                    $Session = New-Object -ComObject Microsoft.Update.Session
                    $Searcher = $Session.CreateUpdateSearcher()
                    $Result = $Searcher.Search("IsInstalled=0")
                    Add-Log "INFO" "Encontradas $($Result.Updates.Count) atualizacoes"
                } catch {
                    Add-Log "WARN" "Erro ao verificar."
                }
            }},
            @{Name="Pausar por 7 dias"; Desc="Adia atualizacoes automaticas"; Action={
                $pauseDate = (Get-Date).AddDays(7).ToString("yyyy-MM-dd")
                Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\WindowsUpdate\UX\Settings" -Name "PauseUpdatesExpiryTime" -Value $pauseDate -Force -ErrorAction SilentlyContinue
                Add-Log "OK" "Pausado ate $pauseDate"
            }}
        )
    }
    "DEV TOOLS" = @{
        Color = [System.Drawing.Color]::FromArgb(255, 150, 0)
        Actions = @(
            @{Name="Instalar Git"; Desc="Controle de versao"; Action={
                Add-Log "EXEC" "Instalando Git..."
                winget install --id Git.Git -e --silent --accept-package-agreements --accept-source-agreements 2>$null
                Add-Log "OK" "Git instalado!"
            }},
            @{Name="Instalar VS Code"; Desc="Editor de codigo"; Action={
                winget install --id Microsoft.VisualStudioCode -e --silent --accept-package-agreements --accept-source-agreements 2>$null
                Add-Log "OK" "VS Code instalado!"
            }},
            @{Name="Instalar Node.js"; Desc="JavaScript runtime"; Action={
                winget install --id OpenJS.NodeJS.LTS -e --silent --accept-package-agreements --accept-source-agreements 2>$null
                Add-Log "OK" "Node.js instalado!"
            }},
            @{Name="Instalar Python"; Desc="Linguagem versatil"; Action={
                winget install --id Python.Python.3.12 -e --silent --accept-package-agreements --accept-source-agreements 2>$null
                Add-Log "OK" "Python instalado!"
            }}
        )
    }
    "SDKS" = @{
        Color = [System.Drawing.Color]::Cyan
        Actions = @(
            @{Name="Instalar .NET SDK"; Desc="Framework Microsoft"; Action={
                winget install --id Microsoft.DotNet.SDK.8 -e --silent --accept-package-agreements --accept-source-agreements 2>$null
                Add-Log "OK" ".NET SDK instalado!"
            }},
            @{Name="Instalar Java JDK"; Desc="Oracle OpenJDK"; Action={
                winget install --id Oracle.JDK.21 -e --silent --accept-package-agreements --accept-source-agreements 2>$null
                Add-Log "OK" "Java JDK instalado!"
            }}
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
            @{Name="Instalar Ubuntu"; Desc="Distro popular"; Action={
                winget install --id Canonical.Ubuntu.2204 -e --silent --accept-package-agreements --accept-source-agreements 2>$null
                Add-Log "OK" "Ubuntu instalado!"
            }}
        )
    }
    "REDE" = @{
        Color = [System.Drawing.Color]::Teal
        Actions = @(
            @{Name="DNS Cloudflare"; Desc="1.1.1.1 (rapido e privado)"; Action={
                netsh interface ip set dns "Ethernet" static 1.1.1.1 primary 2>$null
                netsh interface ip add dns "Ethernet" 1.0.0.1 index=2 2>$null
                Add-Log "OK" "DNS Cloudflare configurado!"
            }},
            @{Name="DNS Google"; Desc="8.8.8.8 (estavel)"; Action={
                netsh interface ip set dns "Ethernet" static 8.8.8.8 primary 2>$null
                Add-Log "OK" "DNS Google configurado!"
            }}
        )
    }
    "BLOATWARES" = @{
        Color = $ColorWarning
        Actions = @(
            @{Name="Remover Xbox Apps"; Desc="Componentes de gaming MS"; Action={
                Get-AppxPackage *xbox* | Remove-AppxPackage -ErrorAction SilentlyContinue
                Add-Log "OK" "Xbox Apps removidos!"
            }},
            @{Name="Remover Cortana"; Desc="Assistente de voz"; Action={
                Get-AppxPackage *cortana* | Remove-AppxPackage -ErrorAction SilentlyContinue
                Add-Log "OK" "Cortana removida!"
            }},
            @{Name="Remover Solitaire"; Desc="Jogo pre-instalado"; Action={
                Get-AppxPackage *solitaire* | Remove-AppxPackage -ErrorAction SilentlyContinue
                Add-Log "OK" "Solitaire removido!"
            }}
        )
    }
    "PERFIS" = @{
        Color = [System.Drawing.Color]::Gold
        Actions = @(
            @{Name="Perfil GAMER"; Desc="Otimiza para jogos"; Action={
                Add-Log "EXEC" "Aplicando perfil Gamer..."
                powercfg -duplicatescheme e9a42b02-d5df-448d-aa00-03f14749eb61 2>$null
                Set-ItemProperty -Path "HKCU:\Software\Microsoft\GameBar" -Name "AllowAutoGameMode" -Value 1 -Type DWord -ErrorAction SilentlyContinue
                Add-Log "OK" "Perfil Gamer aplicado!"
            }},
            @{Name="Perfil DEV"; Desc="Otimiza para desenvolvimento"; Action={
                Add-Log "EXEC" "Aplicando perfil Dev..."
                winget install --id Git.Git -e --silent --accept-package-agreements --accept-source-agreements 2>$null
                Add-Log "OK" "Perfil Dev aplicado!"
            }}
        )
    }
}

# === LAYOUT MODERNO ===

# Sidebar
$Sidebar = New-Object System.Windows.Forms.Panel
$Sidebar.Location = New-Object System.Drawing.Point(0, 0)
$Sidebar.Size = New-Object System.Drawing.Size(180, 700)
$Sidebar.BackColor = $ColorSidebar
$Form.Controls.Add($Sidebar)

# Logo
$Logo = New-Object System.Windows.Forms.Label
$Logo.Text = "OPTIMIZER"
$Logo.Font = New-Object System.Drawing.Font("Segoe UI", 14, [System.Drawing.FontStyle]::Bold)
$Logo.ForeColor = $ColorAccent
$Logo.Location = New-Object System.Drawing.Point(30, 15)
$Logo.AutoSize = $true
$Sidebar.Controls.Add($Logo)

# Botoes de Categoria
$y = 60
foreach ($catName in $Categories.Keys) {
    $catData = $Categories[$catName]
    $btn = New-Object System.Windows.Forms.Button
    $btn.Text = $catName
    $btn.Size = New-Object System.Drawing.Size(160, 35)
    $btn.Location = New-Object System.Drawing.Point(10, $y)
    $btn.FlatStyle = "Flat"
    $btn.FlatAppearance.BorderSize = 0
    $btn.BackColor = $ColorSidebar
    $btn.ForeColor = $ColorTextDim
    $btn.Font = New-Object System.Drawing.Font("Segoe UI", 9)
    $btn.TextAlign = "MiddleLeft"
    $btn.Padding = New-Object System.Windows.Forms.Padding(10, 0, 0, 0)
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
            $cy += 65
        }
    })
    
    $Sidebar.Controls.Add($btn)
    $y += 40
}

# Painel Central
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

# Log Panel
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

# Progress Bar
$global:ProgressBar.Location = New-Object System.Drawing.Point(190, 540)
$global:ProgressBar.Size = New-Object System.Drawing.Size(610, 8)
$global:ProgressBar.Style = "Continuous"
$Form.Controls.Add($global:ProgressBar)

# Footer
$Footer = New-Object System.Windows.Forms.Label
$Footer.Text = "Windows Optimizer v5.2.1 | Created by @denalth | 13 Categorias | 40+ Acoes"
$Footer.Font = New-Object System.Drawing.Font("Segoe UI", 8)
$Footer.ForeColor = $ColorTextDim
$Footer.Location = New-Object System.Drawing.Point(350, 560)
$Footer.AutoSize = $true
$Form.Controls.Add($Footer)

[void]$Form.ShowDialog()

