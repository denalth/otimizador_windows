# Autoria: @denalth
# gui-selector.ps1 - PROTOTIPO GUI SUPREMA v1.0
# Interface grafica moderna para o Otimizador Windows.

Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing

function Show-SupremeGUI {
    $Form = New-Object System.Windows.Forms.Form
    $Form.Text = "Windows Optimizer v2.2 - @denalth"
    $Form.Size = New-Object System.Drawing.Size(500,600)
    $Form.StartPosition = "CenterScreen"
    $Form.BackColor = [System.Drawing.Color]::FromArgb(30, 30, 30)
    $Form.ForeColor = [System.Drawing.Color]::White
    $Form.FormBorderStyle = "FixedDialog"
    $Form.MaximizeBox = $false

    # Icone/Logo Fake
    $LabelTitle = New-Object System.Windows.Forms.Label
    $LabelTitle.Text = "SUPREME OPTIMIZER"
    $LabelTitle.Font = New-Object System.Drawing.Font("Segoe UI", 18, [System.Drawing.FontStyle]::Bold)
    $LabelTitle.ForeColor = [System.Drawing.Color]::Cyan
    $LabelTitle.Location = New-Object System.Drawing.Point(110, 20)
    $LabelTitle.Size = New-Object System.Drawing.Size(300, 40)
    $Form.Controls.Add($LabelTitle)

    $LabelSubTitle = New-Object System.Windows.Forms.Label
    $LabelSubTitle.Text = "Escolha seu Perfil de Performance"
    $LabelSubTitle.Font = New-Object System.Drawing.Font("Segoe UI", 10)
    $LabelSubTitle.Location = New-Object System.Drawing.Point(135, 60)
    $LabelSubTitle.Size = New-Object System.Drawing.Size(250, 20)
    $Form.Controls.Add($LabelSubTitle)

    # Botoes Estilizados
    $btnStyle = {
        param($btn, $text, $y)
        $btn.Text = $text
        $btn.Location = New-Object System.Drawing.Point(100, $y)
        $btn.Size = New-Object System.Drawing.Size(300, 50)
        $btn.FlatStyle = "Flat"
        $btn.BackColor = [System.Drawing.Color]::FromArgb(45, 45, 45)
        $btn.FlatAppearance.BorderSize = 0
        $btn.Font = New-Object System.Drawing.Font("Segoe UI", 11, [System.Drawing.FontStyle]::Bold)
        $btn.Cursor = [System.Windows.Forms.Cursors]::Hand
        return $btn
    }

    $btnDev = New-Object System.Windows.Forms.Button
    $btnDev = &$btnStyle $btnDev "MODO DEV (WSL2 / SDKS)" 120
    $btnDev.Add_Click({ $global:SelectedProfile = "1"; $Form.Close() })
    $Form.Controls.Add($btnDev)

    $btnGamer = New-Object System.Windows.Forms.Button
    $btnGamer = &$btnStyle $btnGamer "MODO GAMER (FPS / PING)" 190
    $btnGamer.Add_Click({ $global:SelectedProfile = "2"; $Form.Close() })
    $Form.Controls.Add($btnGamer)

    $btnWork = New-Object System.Windows.Forms.Button
    $btnWork = &$btnStyle $btnWork "MODO TRABALHO (LIMPEZA)" 260
    $btnWork.Add_Click({ $global:SelectedProfile = "3"; $Form.Close() })
    $Form.Controls.Add($btnWork)

    $btnTerminal = New-Object System.Windows.Forms.Button
    $btnTerminal = &$btnStyle $btnTerminal "VOLTAR AO TERMINAL" 400
    $btnTerminal.BackColor = [System.Drawing.Color]::FromArgb(70, 70, 70)
    $btnTerminal.Add_Click({ $global:SelectedProfile = "0"; $Form.Close() })
    $Form.Controls.Add($btnTerminal)

    $LabelFooter = New-Object System.Windows.Forms.Label
    $LabelFooter.Text = "Powered by @denalth"
    $LabelFooter.Font = New-Object System.Drawing.Font("Segoe UI", 8, [System.Drawing.FontStyle]::Italic)
    $LabelFooter.ForeColor = [System.Drawing.Color]::Gray
    $LabelFooter.Location = New-Object System.Drawing.Point(185, 530)
    $LabelFooter.Size = New-Object System.Drawing.Size(150, 20)
    $Form.Controls.Add($LabelFooter)

    $Form.ShowDialog() | Out-Null
}
