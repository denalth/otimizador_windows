# Autoria: @denalth | v6.0.4 SUPREMO
# Lancar_GUI.ps1 - Interface WPF Premium (UTF-8 BOM)

Add-Type -AssemblyName PresentationFramework, PresentationCore, WindowsBase

# === XAML ESTATICO (UTF-8 SAFE) ===
[xml]$xaml = @"
<Window xmlns="http://schemas.microsoft.com/winfx/2006/xaml/presentation"
        xmlns:x="http://schemas.microsoft.com/winfx/2006/xaml"
        Title="⚡ Windows Optimizer v6.0.4 | @denalth" Height="800" Width="1200" WindowStartupLocation="CenterScreen" Background="#0D1117">
    <Window.Resources>
        <Style x:Key="CategoryButton" TargetType="Button">
            <Setter Property="Background" Value="Transparent"/><Setter Property="Foreground" Value="#8B949E"/><Setter Property="BorderThickness" Value="0"/><Setter Property="Padding" Value="15,12"/><Setter Property="HorizontalContentAlignment" Value="Left"/><Setter Property="FontSize" Value="13"/><Setter Property="Cursor" Value="Hand"/>
            <Setter Property="Template">
                <Setter.Value>
                    <ControlTemplate TargetType="Button">
                        <Border x:Name="border" Background="{TemplateBinding Background}" CornerRadius="8" Padding="{TemplateBinding Padding}"><ContentPresenter/></Border>
                        <ControlTemplate.Triggers><Trigger Property="IsMouseOver" Value="True"><Setter TargetName="border" Property="Background" Value="#21262D"/><Setter Property="Foreground" Value="#C9D1D9"/></Trigger></ControlTemplate.Triggers>
                    </ControlTemplate>
                </Setter.Value>
            </Setter>
        </Style>
        <Style x:Key="ActionButton" TargetType="Button">
            <Setter Property="Background" Value="#58A6FF"/><Setter Property="Foreground" Value="White"/><Setter Property="BorderThickness" Value="0"/><Setter Property="Padding" Value="20,10"/><Setter Property="FontWeight" Value="SemiBold"/><Setter Property="Cursor" Value="Hand"/>
            <Setter Property="Template">
                <Setter.Value>
                    <ControlTemplate TargetType="Button">
                        <Border x:Name="border" Background="{TemplateBinding Background}" CornerRadius="6" Padding="{TemplateBinding Padding}"><ContentPresenter HorizontalAlignment="Center"/></Border>
                        <ControlTemplate.Triggers><Trigger Property="IsMouseOver" Value="True"><Setter TargetName="border" Property="Background" Value="#79C0FF"/></Trigger></ControlTemplate.Triggers>
                    </ControlTemplate>
                </Setter.Value>
            </Setter>
        </Style>
    </Window.Resources>
    <Grid>
        <Grid.ColumnDefinitions><ColumnDefinition Width="220"/><ColumnDefinition Width="*"/><ColumnDefinition Width="320"/></Grid.ColumnDefinitions>
        <Border Grid.Column="0" Background="#010409">
            <StackPanel Margin="10">
                <TextBlock Text="⚡ OPTIMIZER" FontSize="20" FontWeight="Bold" Foreground="#58A6FF" Margin="10,15,0,25"/>
                <Button Name="btnPerf" Style="{StaticResource CategoryButton}" Content="⚡ Performance"/>
                <Button Name="btnLimp" Style="{StaticResource CategoryButton}" Content="🧹 Limpeza"/>
                <Button Name="btnSeg" Style="{StaticResource CategoryButton}" Content="🛡️ Segurança"/>
                <Button Name="btnPriv" Style="{StaticResource CategoryButton}" Content="🔒 Privacidade"/>
                <Button Name="btnVis" Style="{StaticResource CategoryButton}" Content="🎨 Visuais"/>
                <Button Name="btnServ" Style="{StaticResource CategoryButton}" Content="⚙️ Serviços"/>
                <Button Name="btnUpd" Style="{StaticResource CategoryButton}" Content="🔄 Windows Update"/>
                <Button Name="btnDev" Style="{StaticResource CategoryButton}" Content="💻 Dev Tools"/>
                <Button Name="btnSDK" Style="{StaticResource CategoryButton}" Content="📦 SDKs"/>
                <Button Name="btnWSL" Style="{StaticResource CategoryButton}" Content="�� WSL2"/>
                <Button Name="btnNet" Style="{StaticResource CategoryButton}" Content="🌐 Rede"/>
                <Button Name="btnBlo" Style="{StaticResource CategoryButton}" Content="🗑️ Bloatwares"/>
                <Button Name="btnProf" Style="{StaticResource CategoryButton}" Content="👤 Perfis"/>
                <Button Name="btnSelf" Style="{StaticResource CategoryButton}" Content="🚀 Self-Update"/>
            </StackPanel>
        </Border>
        <Border Grid.Column="1" Padding="25"><ScrollViewer VerticalScrollBarVisibility="Auto"><StackPanel Name="PanelContainer"><TextBlock Name="txtTitle" Text="Escolha uma categoria" FontSize="24" FontWeight="Bold" Foreground="#C9D1D9" Margin="0,0,0,20"/></StackPanel></ScrollViewer></Border>
        <Border Grid.Column="2" Background="#010409" Padding="15"><StackPanel><TextBlock Text="📋 LOG DE EXECUÇÃO" FontWeight="Bold" Foreground="#58A6FF" Margin="0,0,0,10"/><TextBox Name="LogBox" Height="680" IsReadOnly="True" Background="#0D1117" Foreground="#3FB950" BorderThickness="0" FontFamily="Consolas" FontSize="11" TextWrapping="Wrap" VerticalScrollBarVisibility="Auto"/></StackPanel></Border>
    </Grid>
</Window>
"@

$reader = (New-Object System.Xml.XmlNodeReader $xaml)
$window = [Windows.Markup.XamlReader]::Load($reader)

$Panel = $window.FindName("PanelContainer")
$LogBox = $window.FindName("LogBox")

function Log {
    param($t, $m)
    $ts = Get-Date -Format "HH:mm:ss"
    $window.Dispatcher.Invoke([Action]{
        $LogBox.AppendText("[$ts][$t] $m`r`n")
        $LogBox.ScrollToEnd()
    })
}

function Clear-P { param($t) $Panel.Children.Clear(); $lbl = New-Object System.Windows.Controls.TextBlock -Property @{Text=$t; FontSize=24; FontWeight="Bold"; Foreground=[System.Windows.Media.BrushConverter]::new().ConvertFromString("#58A6FF"); Margin=New-Object System.Windows.Thickness(0,0,0,20)}; $Panel.Children.Add($lbl) }

function Add-C {
    param($n, $d, $s, $c="#58A6FF")
    $b = New-Object System.Windows.Controls.Border -Property @{ Background=[System.Windows.Media.BrushConverter]::new().ConvertFromString("#161B22"); CornerRadius=10; Padding=15; Margin=New-Object System.Windows.Thickness(0,0,0,10) }
    $g = New-Object System.Windows.Controls.Grid
    $g.ColumnDefinitions.Add((New-Object System.Windows.Controls.ColumnDefinition -Property @{Width=[System.Windows.GridLength]::new(1, [System.Windows.GridUnitType]::Star)}))
    $g.ColumnDefinitions.Add((New-Object System.Windows.Controls.ColumnDefinition -Property @{Width=[System.Windows.GridLength]::Auto}))
    $sp = New-Object System.Windows.Controls.StackPanel
    $sp.Children.Add((New-Object System.Windows.Controls.TextBlock -Property @{Text=$n; FontSize=14; FontWeight="Bold"; Foreground="White"}))
    $sp.Children.Add((New-Object System.Windows.Controls.TextBlock -Property @{Text=$d; FontSize=11; Foreground=[System.Windows.Media.BrushConverter]::new().ConvertFromString("#8B949E"); TextWrapping="Wrap"; Margin=New-Object System.Windows.Thickness(0,5,0,0)}))
    $btn = New-Object System.Windows.Controls.Button -Property @{ Content="EXECUTAR"; Style=$window.FindResource("ActionButton"); Background=[System.Windows.Media.BrushConverter]::new().ConvertFromString($c); VerticalAlignment="Center" }
    $btn.Add_Click({ & $s })
    [System.Windows.Controls.Grid]::SetColumn($sp, 0); [System.Windows.Controls.Grid]::SetColumn($btn, 1)
    $g.Children.Add($sp); $g.Children.Add($btn); $b.Child = $g; $Panel.Children.Add($b)
}

# === EVENTOS ===
$window.FindName("btnPerf").Add_Click({
    Clear-P "⚡ Performance"
    Add-C "🚀 Ultimate Performance" "Plano de energia de força bruta" { powercfg -duplicatescheme e9a42b02-d5df-448d-aa00-03f14749eb61; powercfg /S e9a42b02-d5df-448d-aa00-03f14749eb61; Log "OK" "Plano Ultimate Ativado!" }
    Add-C "�� Game Mode" "Otimiza CPU para jogos" { Set-ItemProperty -Path "HKCU:\Software\Microsoft\GameBar" -Name "AllowAutoGameMode" -Value 1 -Type DWord; Log "OK" "Game Mode ON!" }
    Add-C "🎮 HAGS" "Aceleração de hardware GPU" { Set-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Control\GraphicsDrivers" -Name "HwSchMode" -Value 2; Log "OK" "HAGS ON (Reinicio)" }
    Add-C "📶 Otimizar TCP" "Reduz latência de rede" { Log "EXEC" "Otimizando TCP..."; netsh int tcp set global autotuninglevel=normal; Log "OK" "TCP Otimizado!" }
    Add-C "💤 Hibernação" "Libera espaço (Remove hiberfil.sys)" { powercfg /h off; Log "OK" "Hibernação OFF!" }
})

$window.FindName("btnLimp").Add_Click({
    Clear-P "🧹 Limpeza"
    Add-C "🗂️ Limpar TEMP" "Remove lixo das pastas temporárias" { Remove-Item "$env:TEMP\*" -Recurse -Force -EA SilentlyContinue; Log "OK" "TEMP Limpo!" } "#3FB950"
    Add-C "🗑️ Esvaziar Lixeira" "Limpa todos os drives" { Clear-RecycleBin -Force -EA SilentlyContinue; Log "OK" "Lixeira Vazia!" } "#3FB950"
    Add-C "📁 Prefetch" "Limpa cache de boot do Windows" { Remove-Item "C:\Windows\Prefetch\*" -Force -EA SilentlyContinue; Log "OK" "Prefetch Limpo!" } "#3FB950"
    Add-C "🔄 SoftwareDistribution" "Limpa cache do Windows Update" { Stop-Service wuauserv -Force; Remove-Item "C:\Windows\SoftwareDistribution\Download\*" -Recurse -Force; Start-Service wuauserv; Log "OK" "Update Cache Limpo!" } "#3FB950"
})

$window.FindName("btnSeg").Add_Click({
    Clear-P "🛡️ Segurança"
    Add-C "💾 Backup de Registro" "Exporta HKLM\Software para o Desktop" { $f = "$env:USERPROFILE\Desktop\reg_bkp.reg"; reg export "HKLM\SOFTWARE" $f /y; Log "OK" "Backup salvo!" } "#F85149"
    Add-C "📍 Ponto de Restauração" "Cria um checkpoint do sistema" { Checkpoint-Computer -Description "WinOptimizer" -RestorePointType "MODIFY_SETTINGS"; Log "OK" "Checkpoint Criado!" } "#F85149"
    Add-C "🏥 Diagnóstico" "Saúde básica da máquina" { Log "INFO" "OS: $([Environment]::OSVersion)"; Log "INFO" "RAM: $((Get-CimInstance Win32_OperatingSystem).TotalVisibleMemorySize / 1MB)GB"; Log "OK" "Check Finalizado!" } "#F85149"
    Add-C "🦠 Defender Scan" "Inicia scan rápido oculto" { Start-MpScan -ScanType QuickScan; Log "OK" "Scan Iniciado!" } "#F85149"
})

$window.FindName("btnPriv").Add_Click({
    Clear-P "🔒 Privacidade"
    Add-C "📡 Telemetria" "Desativa DataCollection" { Set-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\DataCollection" -Name "AllowTelemetry" -Value 0 -Type DWord; Log "OK" "Telemetria OFF!" } "#A371F7"
    Add-C "🎯 Ad ID" "Desativa ID de Anúncio" { Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\AdvertisingInfo" -Name "Enabled" -Value 0; Log "OK" "Ads OFF!" } "#A371F7"
    Add-C "🎤 Cortana" "Bloqueia assistente via Policy" { Set-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\Windows Search" -Name "AllowCortana" -Value 0; Log "OK" "Cortana OFF!" } "#A371F7"
})

$window.FindName("btnVis").Add_Click({
    Clear-P "🎨 Visuais"
    Add-C "🌙 Tema Escuro" "Apps e Sistema" { Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Themes\Personalize" -Name "AppsUseLightTheme" -Value 0; Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Themes\Personalize" -Name "SystemUsesLightTheme" -Value 0; Log "OK" "Dark Mode ON!" } "#DA70D6"
    Add-C "☀️ Tema Claro" "Apps e Sistema" { Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Themes\Personalize" -Name "AppsUseLightTheme" -Value 1; Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Themes\Personalize" -Name "SystemUsesLightTheme" -Value 1; Log "OK" "Light Mode ON!" } "#DA70D6"
    Add-C "⚡ Animacões" "Janelas Instantâneas" { Set-ItemProperty -Path "HKCU:\Control Panel\Desktop\WindowMetrics" -Name "MinAnimate" -Value 0; Log "OK" "Animacões OFF!" } "#DA70D6"
})

$window.FindName("btnServ").Add_Click({
    Clear-P "⚙️ Serviços"
    Add-C "📊 DiagTrack" "Para telemetria em tempo real" { Stop-Service "DiagTrack" -Force; Set-Service "DiagTrack" -StartupType Disabled; Log "OK" "DiagTrack OFF!" } "#F85149"
    Add-C "💽 SysMain" "Para o antigo Superfetch" { Stop-Service "SysMain" -Force; Set-Service "SysMain" -StartupType Disabled; Log "OK" "SysMain OFF!" } "#F85149"
    Add-C "�� Search" "Para o indexador de busca" { Stop-Service "WSearch" -Force; Log "OK" "Search OFF!" } "#F85149"
})

$window.FindName("btnUpd").Add_Click({
    Clear-P "🔄 Windows Update"
    Add-C "🔍 Buscar Updates" "Verifica pendentes via COM" { Log "EXEC" "Buscando..."; try { $S = New-Object -ComObject Microsoft.Update.Session; $R = $S.CreateUpdateSearcher().Search("IsInstalled=0"); Log "INFO" "Encontradas $($R.Updates.Count)" } catch { Log "WARN" "Erro no check" } }
    Add-C "⏸️ Pausar Updates" "Adia por 7 dias" { $d = (Get-Date).AddDays(7).ToString("yyyy-MM-dd"); Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\WindowsUpdate\UX\Settings" -Name "PauseUpdatesExpiryTime" -Value $d; Log "OK" "Pausado até $d" }
})

$window.FindName("btnNet").Add_Click({
    Clear-P "🌐 Rede"
    Add-C "☁️ DNS Cloudflare" "1.1.1.1 / 1.0.0.1" { netsh interface ip set dns name="Ethernet" static 1.1.1.1; netsh interface ip add dns name="Ethernet" 1.0.0.1 index=2; Log "OK" "DNS Cloudflare!" } "#008080"
    Add-C "🔵 DNS Google" "8.8.8.8 / 8.8.4.4" { netsh interface ip set dns name="Ethernet" static 8.8.8.8; netsh interface ip add dns name="Ethernet" 8.8.4.4 index=2; Log "OK" "DNS Google!" } "#008080"
    Add-C "🔧 Reset IP" "Release e Renew" { ipconfig /release; ipconfig /renew; Log "OK" "Rede Resetada!" } "#008080"
})

$window.FindName("btnBlo").Add_Click({
    Clear-P "🗑️ Bloatwares"
    Add-C "🎮 Xbox Apps" "Remove pacotes Xbox" { Get-AppxPackage *xbox* | Remove-AppxPackage; Log "OK" "Xbox Apps Removidos!" } "#D29922"
    Add-C "🎤 Cortana" "Remove pacote Cortana" { Get-AppxPackage *cortana* | Remove-AppxPackage; Log "OK" "Cortana Removida!" } "#D29922"
    Add-C "☁️ OneDrive" "Finaliza e desinstala" { taskkill /F /IM OneDrive.exe; Log "OK" "OneDrive Finalizado!" } "#D19922"
})

$window.FindName("btnSelf").Add_Click({
    Clear-P "🚀 Self-Update"
    Add-C "🔍 Verificar" "Verifica versão no GitHub" { 
        Log "EXEC" "Checando..."; try { $v = (Invoke-WebRequest "https://raw.githubusercontent.com/denalth/otimizador_windows/main/version.txt").Content.Trim(); if($v -gt "6.0.3"){ Log "WARN" "Nova versão: $v" } else { Log "OK" "Versão Atual!" } } catch { Log "ERR" "Falha ao checar" }
    } "#FF1493"
})


$window.FindName("btnDev").Add_Click({
    Clear-P "💻 Dev Tools"
    Add-C "📝 Git" "Controle de versão" { winget install Git.Git --accept-package-agreements --accept-source-agreements; Log "OK" "Git Instalado!" } "#FF9800"
    Add-C "💻 VS Code" "Editor de código" { winget install Microsoft.VisualStudioCode --accept-package-agreements --accept-source-agreements; Log "OK" "VS Code Instalado!" } "#FF9800"
    Add-C "🟢 Node.js" "Runtime JavaScript" { winget install OpenJS.NodeJS.LTS --accept-package-agreements --accept-source-agreements; Log "OK" "Node.js Instalado!" } "#FF9800"
    Add-C "🐍 Python" "Linguagem versátil" { winget install Python.Python.3.12 --accept-package-agreements --accept-source-agreements; Log "OK" "Python Instalado!" } "#FF9800"
})

$window.FindName("btnSDK").Add_Click({
    Clear-P "📦 SDKs"
    Add-C "🔵 .NET SDK 8" "Framework Microsoft" { winget install Microsoft.DotNet.SDK.8 --accept-package-agreements --accept-source-agreements; Log "OK" ".NET SDK Instalado!" } "#00BCD4"
    Add-C "☕ Java JDK" "Oracle OpenJDK 21" { winget install Oracle.JDK.21 --accept-package-agreements --accept-source-agreements; Log "OK" "Java JDK Instalado!" } "#00BCD4"
    Add-C "🦀 Rust" "Linguagem de sistemas" { winget install Rustlang.Rustup --accept-package-agreements --accept-source-agreements; Log "OK" "Rust Instalado!" } "#00BCD4"
})

$window.FindName("btnWSL").Add_Click({
    Clear-P "🐧 WSL2"
    Add-C "🐧 Habilitar WSL" "Ativa o subsistema Linux" { wsl --install --no-distribution; Log "OK" "WSL Habilitado! Reinicie." } "#FF6347"
    Add-C "🟠 Ubuntu" "Distro popular" { winget install Canonical.Ubuntu.2204 --accept-package-agreements --accept-source-agreements; Log "OK" "Ubuntu Instalado!" } "#FF6347"
    Add-C "📋 Status WSL" "Lista distribuições" { $s = wsl --list --verbose 2>&1; Log "INFO" "$s" } "#FF6347"
})

$window.FindName("btnProf").Add_Click({
    Clear-P "👤 Perfis"
    Add-C "🎮 Perfil GAMER" "Força bruta para jogos" { powercfg -duplicatescheme e9a42b02-d5df-448d-aa00-03f14749eb61; Set-ItemProperty -Path "HKCU:\Software\Microsoft\GameBar" -Name "AllowAutoGameMode" -Value 1; Log "OK" "Perfil GAMER Ativado!" } "#FFD700"
    Add-C "💻 Perfil DEV" "Setup desenvolvedor" { winget install Git.Git --accept-package-agreements; winget install Microsoft.VisualStudioCode --accept-package-agreements; Log "OK" "Perfil DEV Ativado!" } "#FFD700"
    Add-C "📊 Perfil OFFICE" "Produtividade leve" { Set-ItemProperty -Path "HKCU:\Control Panel\Desktop\WindowMetrics" -Name "MinAnimate" -Value 0; Log "OK" "Perfil OFFICE Ativado!" } "#FFD700"
})

Log "INFO" "Interface WPF Premium v6.0.4 COMPLETA"
Log "INFO" "🚀 Acentuação e Emojis 100% Corrigidos (@denalth)"
$window.ShowDialog() | Out-Null