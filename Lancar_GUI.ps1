# Autoria: @denalth
# Lancar_GUI.ps1 - Windows Optimizer GUI v4.1.1 COMPLETA COM CATEGORIAS

Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing

# ========== CORES ==========
$ColorDark = [System.Drawing.Color]::FromArgb(20, 20, 25)
$ColorCard = [System.Drawing.Color]::FromArgb(35, 35, 45)
$ColorAccent = [System.Drawing.Color]::FromArgb(0, 180, 216)
$ColorText = [System.Drawing.Color]::White
$ColorSuccess = [System.Drawing.Color]::FromArgb(0, 200, 100)
$ColorWarning = [System.Drawing.Color]::FromArgb(255, 180, 0)
$ColorDanger = [System.Drawing.Color]::FromArgb(255, 80, 80)

# ========== VARIAVEIS GLOBAIS ==========
$global:LogBox = $null
$global:ProgressBar = $null
$global:ActionPanel = $null
$global:MainForm = $null

# ========== FUNCOES DE LOG ==========
function Write-Log {
    param([string]$msg, [string]$type = "INFO")
    $timestamp = Get-Date -Format "HH:mm:ss"
    $line = "[$timestamp] [$type] $msg"
    if ($global:LogBox) {
        $global:LogBox.AppendText($line + "`r`n")
        $global:LogBox.SelectionStart = $global:LogBox.Text.Length
        $global:LogBox.ScrollToCaret()
        [System.Windows.Forms.Application]::DoEvents()
    }
}

function Update-Progress {
    param([int]$value)
    if ($global:ProgressBar) {
        $global:ProgressBar.Value = [Math]::Min($value, 100)
        [System.Windows.Forms.Application]::DoEvents()
    }
}

function Show-Confirm {
    param([string]$title, [string]$message)
    $result = [System.Windows.Forms.MessageBox]::Show($message, $title, "YesNo", "Question")
    return ($result -eq "Yes")
}

# ========== DEFINICAO DE CATEGORIAS E ACOES ==========
$Categories = @{
    "Performance" = @{
        Color = $ColorAccent
        Actions = @(
            @{Name = "Ultimate Performance"; Desc = "Ativa plano de energia oculto que maximiza CPU/GPU"; Func = {
                Write-Log "Ativando Ultimate Performance..." "EXEC"
                $Guid = "e9a42b02-d5df-448d-aa00-03f14749eb61"
                powercfg -duplicatescheme $Guid 2>$null
                powercfg /S $Guid
                Write-Log "Ultimate Performance ativado!" "OK"
            }},
            @{Name = "HAGS (GPU Scheduling)"; Desc = "Melhora fluidez em jogos modernos"; Func = {
                Write-Log "Ativando HAGS..." "EXEC"
                Set-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Control\GraphicsDrivers" -Name "HwSchMode" -Value 2 -Type DWord -ErrorAction SilentlyContinue
                Write-Log "HAGS ativado!" "OK"
            }},
            @{Name = "Game Mode"; Desc = "Prioriza recursos para jogos"; Func = {
                Write-Log "Ativando Game Mode..." "EXEC"
                Set-ItemProperty -Path "HKCU:\Software\Microsoft\GameBar" -Name "AllowAutoGameMode" -Value 1 -Type DWord -ErrorAction SilentlyContinue
                Write-Log "Game Mode ativado!" "OK"
            }},
            @{Name = "Otimizar Latencia TCP"; Desc = "Desativa Nagle para menor ping"; Func = {
                Write-Log "Otimizando TCP..." "EXEC"
                $Interfaces = Get-ChildItem "HKLM:\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters\Interfaces" -ErrorAction SilentlyContinue
                foreach ($i in $Interfaces) {
                    New-ItemProperty -Path $i.PSPath -Name "TcpAckFrequency" -Value 1 -PropertyType DWord -Force -ErrorAction SilentlyContinue | Out-Null
                    New-ItemProperty -Path $i.PSPath -Name "TCPNoDelay" -Value 1 -PropertyType DWord -Force -ErrorAction SilentlyContinue | Out-Null
                }
                Write-Log "TCP otimizado!" "OK"
            }}
        )
    }
    "Limpeza" = @{
        Color = $ColorSuccess
        Actions = @(
            @{Name = "Limpar TEMP"; Desc = "Remove arquivos temporarios"; Func = {
                Write-Log "Limpando TEMP..." "EXEC"
                Remove-Item "$env:TEMP\*" -Recurse -Force -ErrorAction SilentlyContinue
                Remove-Item "C:\Windows\Temp\*" -Recurse -Force -ErrorAction SilentlyContinue
                Write-Log "TEMP limpo!" "OK"
            }},
            @{Name = "Esvaziar Lixeira"; Desc = "Remove itens da lixeira"; Func = {
                Write-Log "Esvaziando lixeira..." "EXEC"
                Clear-RecycleBin -Force -ErrorAction SilentlyContinue
                Write-Log "Lixeira vazia!" "OK"
            }},
            @{Name = "Limpar Prefetch"; Desc = "Limpa cache de pre-carregamento"; Func = {
                Write-Log "Limpando Prefetch..." "EXEC"
                Remove-Item "C:\Windows\Prefetch\*" -Force -ErrorAction SilentlyContinue
                Write-Log "Prefetch limpo!" "OK"
            }}
        )
    }
    "Privacidade" = @{
        Color = $ColorWarning
        Actions = @(
            @{Name = "Desativar Telemetria"; Desc = "Impede envio de dados para Microsoft"; Func = {
                Write-Log "Desativando telemetria..." "EXEC"
                $path = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\DataCollection"
                if (-not (Test-Path $path)) { New-Item -Path $path -Force | Out-Null }
                Set-ItemProperty -Path $path -Name "AllowTelemetry" -Value 0 -Type DWord
                Write-Log "Telemetria desativada!" "OK"
            }},
            @{Name = "Desativar Advertising ID"; Desc = "Remove rastreamento de anuncios"; Func = {
                Write-Log "Desativando Advertising ID..." "EXEC"
                Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\AdvertisingInfo" -Name "Enabled" -Value 0 -Type DWord -ErrorAction SilentlyContinue
                Write-Log "Advertising ID desativado!" "OK"
            }},
            @{Name = "Desativar Cortana"; Desc = "Remove assistente de voz"; Func = {
                Write-Log "Desativando Cortana..." "EXEC"
                $path = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\Windows Search"
                if (-not (Test-Path $path)) { New-Item -Path $path -Force | Out-Null }
                Set-ItemProperty -Path $path -Name "AllowCortana" -Value 0 -Type DWord
                Write-Log "Cortana desativada!" "OK"
            }}
        )
    }
    "Visuais" = @{
        Color = [System.Drawing.Color]::FromArgb(150, 100, 255)
        Actions = @(
            @{Name = "Tema Escuro"; Desc = "Aplica modo escuro no sistema"; Func = {
                Write-Log "Ativando tema escuro..." "EXEC"
                Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Themes\Personalize" -Name "AppsUseLightTheme" -Value 0 -Type DWord
                Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Themes\Personalize" -Name "SystemUsesLightTheme" -Value 0 -Type DWord
                Write-Log "Tema escuro ativado!" "OK"
            }},
            @{Name = "Desativar Transparencia"; Desc = "Remove efeito de vidro"; Func = {
                Write-Log "Desativando transparencia..." "EXEC"
                Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Themes\Personalize" -Name "EnableTransparency" -Value 0 -Type DWord
                Write-Log "Transparencia desativada!" "OK"
            }},
            @{Name = "Desativar Animacoes"; Desc = "Janelas abrem instantaneamente"; Func = {
                Write-Log "Desativando animacoes..." "EXEC"
                Set-ItemProperty -Path "HKCU:\Control Panel\Desktop\WindowMetrics" -Name "MinAnimate" -Value 0
                Write-Log "Animacoes desativadas!" "OK"
            }}
        )
    }
    "Servicos" = @{
        Color = $ColorDanger
        Actions = @(
            @{Name = "Desativar DiagTrack"; Desc = "Servico de telemetria"; Func = {
                Write-Log "Desativando DiagTrack..." "EXEC"
                Stop-Service -Name "DiagTrack" -Force -ErrorAction SilentlyContinue
                Set-Service -Name "DiagTrack" -StartupType Disabled -ErrorAction SilentlyContinue
                Write-Log "DiagTrack desativado!" "OK"
            }},
            @{Name = "Desativar SysMain"; Desc = "Superfetch (uso de disco)"; Func = {
                Write-Log "Desativando SysMain..." "EXEC"
                Stop-Service -Name "SysMain" -Force -ErrorAction SilentlyContinue
                Set-Service -Name "SysMain" -StartupType Disabled -ErrorAction SilentlyContinue
                Write-Log "SysMain desativado!" "OK"
            }}
        )
    }
    "Windows Update" = @{
        Color = [System.Drawing.Color]::FromArgb(0, 120, 215)
        Actions = @(
            @{Name = "Verificar Atualizacoes"; Desc = "Busca atualizacoes disponiveis"; Func = {
                Write-Log "Verificando atualizacoes..." "EXEC"
                try {
                    $Session = New-Object -ComObject Microsoft.Update.Session
                    $Searcher = $Session.CreateUpdateSearcher()
                    $Result = $Searcher.Search("IsInstalled=0")
                    Write-Log "Encontradas $($Result.Updates.Count) atualizacoes" "INFO"
                } catch {
                    Write-Log "Erro ao verificar: $($_.Exception.Message)" "ERRO"
                }
            }},
            @{Name = "Pausar por 7 dias"; Desc = "Adia atualizacoes automaticas"; Func = {
                Write-Log "Pausando atualizacoes..." "EXEC"
                $pauseDate = (Get-Date).AddDays(7).ToString("yyyy-MM-dd")
                Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\WindowsUpdate\UX\Settings" -Name "PauseUpdatesExpiryTime" -Value $pauseDate -Force -ErrorAction SilentlyContinue
                Write-Log "Pausado ate $pauseDate" "OK"
            }},
            @{Name = "Retomar Atualizacoes"; Desc = "Remove a pausa de updates"; Func = {
                Write-Log "Retomando atualizacoes..." "EXEC"
                Remove-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\WindowsUpdate\UX\Settings" -Name "PauseUpdatesExpiryTime" -Force -ErrorAction SilentlyContinue
                Write-Log "Atualizacoes retomadas!" "OK"
            }}
        )
    }
    "Dev Tools" = @{
        Color = [System.Drawing.Color]::FromArgb(255, 150, 0)
        Actions = @(
            @{Name = "Instalar Git"; Desc = "Controle de versao"; Func = {
                Write-Log "Instalando Git..." "EXEC"
                winget install --id Git.Git -e --silent --accept-package-agreements --accept-source-agreements 2>$null
                Write-Log "Git instalado!" "OK"
            }},
            @{Name = "Instalar VS Code"; Desc = "Editor de codigo"; Func = {
                Write-Log "Instalando VS Code..." "EXEC"
                winget install --id Microsoft.VisualStudioCode -e --silent --accept-package-agreements --accept-source-agreements 2>$null
                Write-Log "VS Code instalado!" "OK"
            }},
            @{Name = "Instalar Node.js"; Desc = "JavaScript runtime"; Func = {
                Write-Log "Instalando Node.js..." "EXEC"
                winget install --id OpenJS.NodeJS.LTS -e --silent --accept-package-agreements --accept-source-agreements 2>$null
                Write-Log "Node.js instalado!" "OK"
            }},
            @{Name = "Instalar Python"; Desc = "Linguagem versatil"; Func = {
                Write-Log "Instalando Python..." "EXEC"
                winget install --id Python.Python.3.12 -e --silent --accept-package-agreements --accept-source-agreements 2>$null
                Write-Log "Python instalado!" "OK"
            }}
        )
    }
}

# ========== FUNCAO PARA MOSTRAR ACOES DE UMA CATEGORIA ==========
function Show-CategoryActions {
    param([string]$catName, [hashtable]$catData)

    $global:ActionPanel.Controls.Clear()
    $global:LogBox.Clear()
    $global:ProgressBar.Value = 0

    $titleLabel = New-Object System.Windows.Forms.Label
    $titleLabel.Text = $catName
    $titleLabel.Font = New-Object System.Drawing.Font("Segoe UI", 14, [System.Drawing.FontStyle]::Bold)
    $titleLabel.ForeColor = $catData.Color
    $titleLabel.Location = New-Object System.Drawing.Point(10, 5)
    $titleLabel.AutoSize = $true
    $global:ActionPanel.Controls.Add($titleLabel)

    $yPos = 40
    $actionCount = $catData.Actions.Count
    $idx = 0

    foreach ($action in $catData.Actions) {
        $idx++
        $panel = New-Object System.Windows.Forms.Panel
        $panel.Location = New-Object System.Drawing.Point(10, $yPos)
        $panel.Size = New-Object System.Drawing.Size(280, 55)
        $panel.BackColor = $ColorCard

        $nameLabel = New-Object System.Windows.Forms.Label
        $nameLabel.Text = $action.Name
        $nameLabel.Font = New-Object System.Drawing.Font("Segoe UI", 10, [System.Drawing.FontStyle]::Bold)
        $nameLabel.ForeColor = $ColorText
        $nameLabel.Location = New-Object System.Drawing.Point(10, 5)
        $nameLabel.AutoSize = $true
        $panel.Controls.Add($nameLabel)

        $descLabel = New-Object System.Windows.Forms.Label
        $descLabel.Text = $action.Desc
        $descLabel.Font = New-Object System.Drawing.Font("Segoe UI", 8)
        $descLabel.ForeColor = [System.Drawing.Color]::Gray
        $descLabel.Location = New-Object System.Drawing.Point(10, 25)
        $descLabel.Size = New-Object System.Drawing.Size(200, 25)
        $panel.Controls.Add($descLabel)

        $btn = New-Object System.Windows.Forms.Button
        $btn.Text = "Executar"
        $btn.Location = New-Object System.Drawing.Point(210, 12)
        $btn.Size = New-Object System.Drawing.Size(60, 30)
        $btn.FlatStyle = "Flat"
        $btn.BackColor = $catData.Color
        $btn.ForeColor = $ColorText
        $btn.Font = New-Object System.Drawing.Font("Segoe UI", 8, [System.Drawing.FontStyle]::Bold)
        $btn.FlatAppearance.BorderSize = 0
        $btn.Tag = @{Func = $action.Func; Name = $action.Name; Desc = $action.Desc; Idx = $idx; Total = $actionCount}
        $btn.Add_Click({
            $data = $this.Tag
            if (Show-Confirm $data.Name $data.Desc) {
                Update-Progress ([int](($data.Idx / $data.Total) * 100))
                & $data.Func
            }
        })
        $panel.Controls.Add($btn)

        $global:ActionPanel.Controls.Add($panel)
        $yPos += 65
    }
}

# ========== LOGIN ==========
function Show-LoginWindow {
    $LoginForm = New-Object System.Windows.Forms.Form
    $LoginForm.Text = "Windows Optimizer - @denalth"
    $LoginForm.Size = New-Object System.Drawing.Size(400, 280)
    $LoginForm.StartPosition = "CenterScreen"
    $LoginForm.BackColor = $ColorDark
    $LoginForm.FormBorderStyle = "FixedDialog"
    $LoginForm.MaximizeBox = $false

    $Title = New-Object System.Windows.Forms.Label
    $Title.Text = "ACESSO RESTRITO"
    $Title.Font = New-Object System.Drawing.Font("Segoe UI", 16, [System.Drawing.FontStyle]::Bold)
    $Title.ForeColor = $ColorAccent
    $Title.Location = New-Object System.Drawing.Point(100, 40)
    $Title.AutoSize = $true
    $LoginForm.Controls.Add($Title)

    $SubTitle = New-Object System.Windows.Forms.Label
    $SubTitle.Text = "Digite a senha para continuar"
    $SubTitle.Font = New-Object System.Drawing.Font("Segoe UI", 10)
    $SubTitle.ForeColor = [System.Drawing.Color]::Gray
    $SubTitle.Location = New-Object System.Drawing.Point(115, 80)
    $SubTitle.AutoSize = $true
    $LoginForm.Controls.Add($SubTitle)

    $InputBox = New-Object System.Windows.Forms.TextBox
    $InputBox.Location = New-Object System.Drawing.Point(75, 120)
    $InputBox.Size = New-Object System.Drawing.Size(250, 30)
    $InputBox.Font = New-Object System.Drawing.Font("Segoe UI", 12)
    $InputBox.BackColor = $ColorCard
    $InputBox.ForeColor = $ColorText
    $InputBox.BorderStyle = "FixedSingle"
    $InputBox.UseSystemPasswordChar = $true
    $LoginForm.Controls.Add($InputBox)

    $BtnLogin = New-Object System.Windows.Forms.Button
    $BtnLogin.Text = "ENTRAR"
    $BtnLogin.Location = New-Object System.Drawing.Point(75, 170)
    $BtnLogin.Size = New-Object System.Drawing.Size(250, 45)
    $BtnLogin.FlatStyle = "Flat"
    $BtnLogin.BackColor = $ColorAccent
    $BtnLogin.ForeColor = $ColorText
    $BtnLogin.Font = New-Object System.Drawing.Font("Segoe UI", 11, [System.Drawing.FontStyle]::Bold)
    $BtnLogin.Add_Click({
        if ($InputBox.Text -eq "@denalth") {
            $global:Authenticated = $true
            $LoginForm.Close()
        } else {
            [System.Windows.Forms.MessageBox]::Show("Senha incorreta!", "Acesso Negado", "OK", "Error")
        }
    })
    $LoginForm.Controls.Add($BtnLogin)
    $LoginForm.AcceptButton = $BtnLogin

    $global:Authenticated = $false
    $LoginForm.ShowDialog() | Out-Null
    return $global:Authenticated
}

# ========== JANELA PRINCIPAL ==========
function Show-MainWindow {
    $global:MainForm = New-Object System.Windows.Forms.Form
    $global:MainForm.Text = "Windows Optimizer v4.1.1 - by @denalth"
    $global:MainForm.Size = New-Object System.Drawing.Size(900, 650)
    $global:MainForm.StartPosition = "CenterScreen"
    $global:MainForm.BackColor = $ColorDark
    $global:MainForm.FormBorderStyle = "FixedDialog"
    $global:MainForm.MaximizeBox = $false

    # Header
    $Header = New-Object System.Windows.Forms.Label
    $Header.Text = "WINDOWS OPTIMIZER v4.1.1"
    $Header.Font = New-Object System.Drawing.Font("Segoe UI", 18, [System.Drawing.FontStyle]::Bold)
    $Header.ForeColor = $ColorAccent
    $Header.Location = New-Object System.Drawing.Point(300, 10)
    $Header.AutoSize = $true
    $global:MainForm.Controls.Add($Header)

    # Painel de Categorias (Esquerda)
    $catLabel = New-Object System.Windows.Forms.Label
    $catLabel.Text = "CATEGORIAS"
    $catLabel.Font = New-Object System.Drawing.Font("Segoe UI", 10, [System.Drawing.FontStyle]::Bold)
    $catLabel.ForeColor = [System.Drawing.Color]::Gray
    $catLabel.Location = New-Object System.Drawing.Point(20, 50)
    $catLabel.AutoSize = $true
    $global:MainForm.Controls.Add($catLabel)

    $yPos = 75
    foreach ($catName in $Categories.Keys) {
        $catData = $Categories[$catName]
        $btn = New-Object System.Windows.Forms.Button
        $btn.Text = $catName
        $btn.Location = New-Object System.Drawing.Point(15, $yPos)
        $btn.Size = New-Object System.Drawing.Size(150, 40)
        $btn.FlatStyle = "Flat"
        $btn.BackColor = $catData.Color
        $btn.ForeColor = $ColorText
        $btn.Font = New-Object System.Drawing.Font("Segoe UI", 9, [System.Drawing.FontStyle]::Bold)
        $btn.FlatAppearance.BorderSize = 0
        $btn.Tag = @{Name = $catName; Data = $catData}
        $btn.Add_Click({
            Show-CategoryActions -catName $this.Tag.Name -catData $this.Tag.Data
        })
        $global:MainForm.Controls.Add($btn)
        $yPos += 50
    }

    # Painel de Acoes (Centro)
    $global:ActionPanel = New-Object System.Windows.Forms.Panel
    $global:ActionPanel.Location = New-Object System.Drawing.Point(180, 50)
    $global:ActionPanel.Size = New-Object System.Drawing.Size(310, 500)
    $global:ActionPanel.BackColor = [System.Drawing.Color]::FromArgb(25, 25, 30)
    $global:ActionPanel.AutoScroll = $true
    $global:MainForm.Controls.Add($global:ActionPanel)

    $welcomeLabel = New-Object System.Windows.Forms.Label
    $welcomeLabel.Text = "Selecione uma categoria"
    $welcomeLabel.Font = New-Object System.Drawing.Font("Segoe UI", 12)
    $welcomeLabel.ForeColor = [System.Drawing.Color]::Gray
    $welcomeLabel.Location = New-Object System.Drawing.Point(60, 200)
    $welcomeLabel.AutoSize = $true
    $global:ActionPanel.Controls.Add($welcomeLabel)

    # Log Box (Direita)
    $logLabel = New-Object System.Windows.Forms.Label
    $logLabel.Text = "LOG DE EXECUCAO"
    $logLabel.Font = New-Object System.Drawing.Font("Segoe UI", 10, [System.Drawing.FontStyle]::Bold)
    $logLabel.ForeColor = [System.Drawing.Color]::Gray
    $logLabel.Location = New-Object System.Drawing.Point(510, 50)
    $logLabel.AutoSize = $true
    $global:MainForm.Controls.Add($logLabel)

    $global:LogBox = New-Object System.Windows.Forms.TextBox
    $global:LogBox.Multiline = $true
    $global:LogBox.ScrollBars = "Vertical"
    $global:LogBox.Location = New-Object System.Drawing.Point(510, 75)
    $global:LogBox.Size = New-Object System.Drawing.Size(360, 420)
    $global:LogBox.Font = New-Object System.Drawing.Font("Consolas", 9)
    $global:LogBox.BackColor = [System.Drawing.Color]::FromArgb(15, 15, 20)
    $global:LogBox.ForeColor = $ColorSuccess
    $global:LogBox.ReadOnly = $true
    $global:MainForm.Controls.Add($global:LogBox)

    # Barra de Progresso
    $global:ProgressBar = New-Object System.Windows.Forms.ProgressBar
    $global:ProgressBar.Location = New-Object System.Drawing.Point(510, 505)
    $global:ProgressBar.Size = New-Object System.Drawing.Size(360, 25)
    $global:ProgressBar.Style = "Continuous"
    $global:MainForm.Controls.Add($global:ProgressBar)

    # Footer
    $Footer = New-Object System.Windows.Forms.Label
    $Footer.Text = "Powered by @denalth | Windows Optimizer v4.1.1 | 7 Categorias | 20+ Acoes"
    $Footer.Font = New-Object System.Drawing.Font("Segoe UI", 9)
    $Footer.ForeColor = [System.Drawing.Color]::Gray
    $Footer.Location = New-Object System.Drawing.Point(260, 575)
    $Footer.AutoSize = $true
    $global:MainForm.Controls.Add($Footer)

    $global:MainForm.ShowDialog() | Out-Null
}

# ========== INICIAR ==========
if (Show-LoginWindow) {
    Show-MainWindow
}
