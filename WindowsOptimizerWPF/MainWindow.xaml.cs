using System;
using System.Diagnostics;
using System.IO;
using System.Windows;
using System.Windows.Controls;
using System.Windows.Media;
using Microsoft.Win32;
using System.ServiceProcess;
using System.Management;

namespace WindowsOptimizer
{
    public partial class MainWindow : Window
    {
        public MainWindow()
        {
            InitializeComponent();
            AddLog("INFO", "🚀 Windows Optimizer v6.0.0 iniciado!");
            AddLog("INFO", "👋 Bem-vindo, @denalth!");
        }

        private void AddLog(string type, string message)
        {
            string timestamp = DateTime.Now.ToString("HH:mm:ss");
            LogBox.AppendText($"[{timestamp}][{type}] {message}\n");
            LogBox.ScrollToEnd();
        }

        private void Category_Click(object sender, RoutedEventArgs e)
        {
            var btn = sender as Button;
            string category = btn.Tag.ToString();
            LoadCategory(category);
        }

        private void LoadCategory(string category)
        {
            ActionPanel.Children.Clear();
            
            var title = new TextBlock
            {
                FontSize = 24,
                FontWeight = FontWeights.Bold,
                Foreground = new SolidColorBrush((Color)ColorConverter.ConvertFromString("#58A6FF")),
                Margin = new Thickness(0, 0, 0, 20)
            };
            
            switch (category)
            {
                case "PERFORMANCE":
                    title.Text = "⚡ Performance";
                    ActionPanel.Children.Add(title);
                    AddActionCard("🚀 Ultimate Performance", "Ativa o plano de energia oculto de máximo desempenho", () => RunUltimatePerformance());
                    AddActionCard("🎮 HAGS (GPU Scheduling)", "Melhora a fluidez em jogos com agendamento de GPU", () => RunHAGS());
                    AddActionCard("🕹️ Game Mode", "Prioriza recursos do sistema para jogos", () => RunGameMode());
                    AddActionCard("📶 Otimizar TCP/IP", "Reduz latência de rede para melhor ping", () => RunTCPOptimize());
                    AddActionCard("💤 Desativar Hibernação", "Libera espaço em disco removendo hiberfil.sys", () => RunDisableHibernation());
                    AddActionCard("🔋 Relatório de Energia", "Gera diagnóstico completo de energia e abre no navegador", () => RunEnergyReport());
                    break;
                    
                case "LIMPEZA":
                    title.Text = "🧹 Limpeza";
                    ActionPanel.Children.Add(title);
                    AddActionCard("🗂️ Limpar TEMP", "Remove arquivos temporários do usuário e sistema", () => RunCleanTemp());
                    AddActionCard("🗑️ Esvaziar Lixeira", "Limpa a lixeira de todos os drives", () => RunEmptyRecycleBin());
                    AddActionCard("📁 Limpar Prefetch", "Remove cache de pré-carregamento do Windows", () => RunCleanPrefetch());
                    AddActionCard("🌐 Limpar Cache DNS", "Resolve problemas de conexão limpando o cache DNS", () => RunFlushDNS());
                    AddActionCard("🔄 Limpar SoftwareDistribution", "Remove cache do Windows Update", () => RunCleanSoftwareDistribution());
                    break;
                    
                case "SEGURANCA":
                    title.Text = "🛡️ Segurança";
                    ActionPanel.Children.Add(title);
                    AddActionCard("💾 Backup de Registro", "Salva o estado atual do registro do Windows", () => RunRegistryBackup());
                    AddActionCard("�� Ponto de Restauração", "Cria um checkpoint do sistema Windows", () => RunCreateRestorePoint());
                    AddActionCard("🏥 Diagnóstico de Saúde", "Mostra informações de CPU, RAM, Disco e Sistema", () => RunHealthDiagnostic());
                    AddActionCard("🦠 Windows Defender Scan", "Inicia uma verificação rápida de ameaças", () => RunDefenderScan());
                    break;
                    
                case "PRIVACIDADE":
                    title.Text = "🔒 Privacidade";
                    ActionPanel.Children.Add(title);
                    AddActionCard("📡 Desativar Telemetria", "Impede o envio de dados de uso para a Microsoft", () => RunDisableTelemetry());
                    AddActionCard("🎯 Desativar Advertising ID", "Remove rastreamento de anúncios personalizados", () => RunDisableAdvertisingID());
                    AddActionCard("🎤 Desativar Cortana", "Desliga a assistente de voz da Microsoft", () => RunDisableCortana());
                    AddActionCard("📅 Desativar Timeline", "Remove o histórico de atividades do Windows", () => RunDisableTimeline());
                    break;
                    
                case "VISUAIS":
                    title.Text = "🎨 Visuais";
                    ActionPanel.Children.Add(title);
                    AddActionCard("🌙 Tema Escuro", "Ativa o modo escuro em todo o sistema", () => RunDarkTheme());
                    AddActionCard("☀️ Tema Claro", "Ativa o modo claro em todo o sistema", () => RunLightTheme());
                    AddActionCard("🪟 Desativar Transparência", "Remove o efeito de vidro das janelas", () => RunDisableTransparency());
                    AddActionCard("⚡ Desativar Animações", "Torna as janelas instantâneas sem animação", () => RunDisableAnimations());
                    break;
                    
                case "SERVICOS":
                    title.Text = "⚙️ Serviços";
                    ActionPanel.Children.Add(title);
                    AddActionCard("📊 Desativar DiagTrack", "Para o serviço de telemetria do Windows", () => RunDisableDiagTrack());
                    AddActionCard("💽 Desativar SysMain", "Desliga o Superfetch para liberar recursos", () => RunDisableSysMain());
                    AddActionCard("🔍 Desativar Windows Search", "Para o indexador de busca do Windows", () => RunDisableSearch());
                    AddActionCard("🎮 Desativar Xbox Services", "Para todos os serviços de gaming da Microsoft", () => RunDisableXboxServices());
                    break;
                    
                case "UPDATE":
                    title.Text = "🔄 Windows Update";
                    ActionPanel.Children.Add(title);
                    AddActionCard("🔍 Verificar Atualizações", "Busca novas atualizações disponíveis", () => RunCheckUpdates());
                    AddActionCard("⏸️ Pausar por 7 dias", "Adia as atualizações por uma semana", () => RunPauseUpdates());
                    AddActionCard("▶️ Retomar Atualizações", "Remove a pausa e permite updates", () => RunResumeUpdates());
                    break;
                    
                case "DEVTOOLS":
                    title.Text = "💻 Dev Tools";
                    ActionPanel.Children.Add(title);
                    AddActionCard("📝 Instalar Git", "Sistema de controle de versão", () => InstallPackage("Git.Git", "Git"));
                    AddActionCard("💻 Instalar VS Code", "Editor de código leve e poderoso", () => InstallPackage("Microsoft.VisualStudioCode", "VS Code"));
                    AddActionCard("🟢 Instalar Node.js", "Runtime JavaScript para desenvolvimento web", () => InstallPackage("OpenJS.NodeJS.LTS", "Node.js"));
                    AddActionCard("🐍 Instalar Python", "Linguagem versátil para scripts e IA", () => InstallPackage("Python.Python.3.12", "Python"));
                    AddActionCard("�� Instalar Docker", "Containerização de aplicações", () => InstallPackage("Docker.DockerDesktop", "Docker"));
                    break;
                    
                case "SDKS":
                    title.Text = "📦 SDKs";
                    ActionPanel.Children.Add(title);
                    AddActionCard("🔵 Instalar .NET SDK", "Framework da Microsoft para desenvolvimento", () => InstallPackage("Microsoft.DotNet.SDK.8", ".NET SDK 8"));
                    AddActionCard("☕ Instalar Java JDK", "Kit de desenvolvimento Java", () => InstallPackage("Oracle.JDK.21", "Java JDK 21"));
                    AddActionCard("🦀 Instalar Rust", "Linguagem de sistemas de alto desempenho", () => InstallPackage("Rustlang.Rustup", "Rust"));
                    AddActionCard("🔷 Instalar Go", "Linguagem rápida do Google", () => InstallPackage("GoLang.Go", "Go"));
                    break;
                    
                case "WSL2":
                    title.Text = "🐧 WSL2";
                    ActionPanel.Children.Add(title);
                    AddActionCard("🐧 Habilitar WSL2", "Ativa o Subsistema Windows para Linux", () => RunEnableWSL());
                    AddActionCard("🟠 Instalar Ubuntu", "Distribuição Linux popular e amigável", () => InstallPackage("Canonical.Ubuntu.2204", "Ubuntu 22.04"));
                    AddActionCard("🔴 Instalar Debian", "Distribuição Linux estável e confiável", () => InstallPackage("Debian.Debian", "Debian"));
                    AddActionCard("📋 Status WSL", "Lista as distribuições instaladas", () => RunWSLStatus());
                    break;
                    
                case "REDE":
                    title.Text = "🌐 Rede";
                    ActionPanel.Children.Add(title);
                    AddActionCard("☁️ DNS Cloudflare", "Configura DNS rápido 1.1.1.1", () => RunDNSCloudflare());
                    AddActionCard("🔵 DNS Google", "Configura DNS confiável 8.8.8.8", () => RunDNSGoogle());
                    AddActionCard("🔧 Reset Winsock", "Corrige problemas de rede resetando pilha TCP/IP", () => RunResetWinsock());
                    AddActionCard("🔄 Renovar IP", "Solicita novo IP do servidor DHCP", () => RunRenewIP());
                    break;
                    
                case "BLOATWARES":
                    title.Text = "🗑️ Bloatwares";
                    ActionPanel.Children.Add(title);
                    AddActionCard("🎮 Remover Xbox Apps", "Remove o Xbox Game Bar e apps relacionados", () => RunRemoveXbox());
                    AddActionCard("🎤 Remover Cortana", "Remove a assistente de voz completamente", () => RunRemoveCortana());
                    AddActionCard("🃏 Remover Solitaire", "Remove os jogos pré-instalados", () => RunRemoveSolitaire());
                    AddActionCard("💬 Remover Skype", "Remove o Skype do sistema", () => RunRemoveSkype());
                    AddActionCard("☁️ Remover OneDrive", "Desinstala o OneDrive completamente", () => RunRemoveOneDrive());
                    break;
                    
                case "PERFIS":
                    title.Text = "👤 Perfis";
                    ActionPanel.Children.Add(title);
                    AddActionCard("🎮 Perfil GAMER", "Otimiza o sistema para máximo desempenho em jogos", () => RunProfileGamer());
                    AddActionCard("💻 Perfil DEV", "Instala ferramentas essenciais para desenvolvedores", () => RunProfileDev());
                    AddActionCard("📊 Perfil OFFICE", "Otimiza para trabalho e produtividade", () => RunProfileOffice());
                    break;
                    
                case "SELFUPDATE":
                    title.Text = "🚀 Self-Update";
                    ActionPanel.Children.Add(title);
                    AddActionCard("🔍 Verificar Nova Versão", "Compara sua versão com a mais recente no GitHub", () => RunCheckVersion());
                    AddActionCard("🌐 Abrir GitHub Releases", "Abre a página de downloads do projeto", () => RunOpenGitHub());
                    break;
            }
        }

        private void AddActionCard(string name, string description, Action action)
        {
            var card = new Border
            {
                Background = new SolidColorBrush((Color)ColorConverter.ConvertFromString("#161B22")),
                CornerRadius = new CornerRadius(10),
                Padding = new Thickness(15),
                Margin = new Thickness(0, 0, 0, 10)
            };

            var grid = new Grid();
            grid.ColumnDefinitions.Add(new ColumnDefinition { Width = new GridLength(1, GridUnitType.Star) });
            grid.ColumnDefinitions.Add(new ColumnDefinition { Width = GridLength.Auto });

            var textPanel = new StackPanel();
            textPanel.Children.Add(new TextBlock
            {
                Text = name,
                FontSize = 14,
                FontWeight = FontWeights.SemiBold,
                Foreground = new SolidColorBrush(Colors.White)
            });
            textPanel.Children.Add(new TextBlock
            {
                Text = description,
                FontSize = 12,
                Foreground = new SolidColorBrush((Color)ColorConverter.ConvertFromString("#8B949E")),
                Margin = new Thickness(0, 5, 0, 0),
                TextWrapping = TextWrapping.Wrap
            });

            var btn = new Button
            {
                Content = "EXECUTAR",
                Style = (Style)FindResource("ActionButton"),
                VerticalAlignment = VerticalAlignment.Center
            };
            btn.Click += (s, e) => action();

            Grid.SetColumn(textPanel, 0);
            Grid.SetColumn(btn, 1);
            grid.Children.Add(textPanel);
            grid.Children.Add(btn);
            card.Child = grid;
            ActionPanel.Children.Add(card);
        }

        // === IMPLEMENTAÇÕES DAS AÇÕES ===
        
        private void RunCommand(string cmd, string args = "")
        {
            try
            {
                var psi = new ProcessStartInfo
                {
                    FileName = cmd,
                    Arguments = args,
                    UseShellExecute = false,
                    CreateNoWindow = true,
                    RedirectStandardOutput = true,
                    RedirectStandardError = true
                };
                var proc = Process.Start(psi);
                proc.WaitForExit();
            }
            catch (Exception ex)
            {
                AddLog("ERRO", ex.Message);
            }
        }

        private void SetRegistry(string path, string name, object value, RegistryValueKind kind = RegistryValueKind.DWord)
        {
            try
            {
                using (var key = Registry.LocalMachine.CreateSubKey(path.Replace("HKLM\\", "")))
                {
                    key?.SetValue(name, value, kind);
                }
                AddLog("OK", $"Registro atualizado: {name}");
            }
            catch
            {
                try
                {
                    using (var key = Registry.CurrentUser.CreateSubKey(path.Replace("HKCU\\", "")))
                    {
                        key?.SetValue(name, value, kind);
                    }
                    AddLog("OK", $"Registro atualizado: {name}");
                }
                catch (Exception ex)
                {
                    AddLog("ERRO", ex.Message);
                }
            }
        }

        private void InstallPackage(string packageId, string name)
        {
            AddLog("EXEC", $"Verificando {name}...");
            var psi = new ProcessStartInfo
            {
                FileName = "winget",
                Arguments = $"install --id {packageId} -e --accept-package-agreements --accept-source-agreements",
                UseShellExecute = false,
                CreateNoWindow = true,
                RedirectStandardOutput = true
            };
            var proc = Process.Start(psi);
            while (!proc.HasExited)
            {
                string line = proc.StandardOutput.ReadLine();
                if (!string.IsNullOrEmpty(line))
                    AddLog("WINGET", line.Trim());
            }
            AddLog("OK", $"{name} processado!");
        }

        // Performance
        private void RunUltimatePerformance()
        {
            AddLog("EXEC", "Ativando Ultimate Performance...");
            RunCommand("powercfg", "-duplicatescheme e9a42b02-d5df-448d-aa00-03f14749eb61");
            RunCommand("powercfg", "/S e9a42b02-d5df-448d-aa00-03f14749eb61");
            AddLog("OK", "🚀 Plano Ultimate Performance ativado!");
        }

        private void RunHAGS()
        {
            SetRegistry(@"SYSTEM\CurrentControlSet\Control\GraphicsDrivers", "HwSchMode", 2);
            AddLog("OK", "🎮 HAGS ativado! Reinicie para aplicar.");
        }

        private void RunGameMode()
        {
            SetRegistry(@"Software\Microsoft\GameBar", "AllowAutoGameMode", 1);
            AddLog("OK", "🕹️ Game Mode ativado!");
        }

        private void RunTCPOptimize()
        {
            AddLog("EXEC", "Otimizando TCP/IP...");
            RunCommand("netsh", "int tcp set global autotuninglevel=normal");
            AddLog("OK", "📶 TCP/IP otimizado!");
        }

        private void RunDisableHibernation()
        {
            RunCommand("powercfg", "/h off");
            AddLog("OK", "💤 Hibernação desativada!");
        }

        private void RunEnergyReport()
        {
            string report = Path.Combine(Environment.GetFolderPath(Environment.SpecialFolder.Desktop), "energy-report.html");
            AddLog("EXEC", "Gerando relatório de energia...");
            RunCommand("powercfg", $"/energy /output \"{report}\"");
            System.Threading.Thread.Sleep(3000);
            if (File.Exists(report))
            {
                Process.Start(new ProcessStartInfo(report) { UseShellExecute = true });
                AddLog("OK", $"🔋 Relatório aberto: {report}");
            }
            else
            {
                AddLog("WARN", "Falha ao gerar relatório.");
            }
        }

        // Limpeza
        private void RunCleanTemp()
        {
            AddLog("EXEC", "Limpando TEMP...");
            try
            {
                foreach (var file in Directory.GetFiles(Path.GetTempPath(), "*", SearchOption.AllDirectories))
                {
                    try { File.Delete(file); } catch { }
                }
                AddLog("OK", "🗂️ Arquivos temporários limpos!");
            }
            catch { AddLog("WARN", "Alguns arquivos não puderam ser removidos."); }
        }

        private void RunEmptyRecycleBin()
        {
            RunCommand("cmd", "/c rd /s /q C:\\$Recycle.Bin");
            AddLog("OK", "🗑️ Lixeira esvaziada!");
        }

        private void RunCleanPrefetch()
        {
            RunCommand("cmd", "/c del /q /f C:\\Windows\\Prefetch\\*");
            AddLog("OK", "📁 Prefetch limpo!");
        }

        private void RunFlushDNS()
        {
            RunCommand("ipconfig", "/flushdns");
            AddLog("OK", "🌐 Cache DNS limpo!");
        }

        private void RunCleanSoftwareDistribution()
        {
            RunCommand("net", "stop wuauserv");
            RunCommand("cmd", "/c rd /s /q C:\\Windows\\SoftwareDistribution\\Download");
            RunCommand("net", "start wuauserv");
            AddLog("OK", "🔄 Cache do Windows Update limpo!");
        }

        // Segurança
        private void RunRegistryBackup()
        {
            string dir = Path.Combine(Environment.GetFolderPath(Environment.SpecialFolder.UserProfile), "WindowsOptimizerBackups");
            Directory.CreateDirectory(dir);
            string file = Path.Combine(dir, $"backup_{DateTime.Now:yyyyMMdd_HHmmss}.reg");
            RunCommand("reg", $"export \"HKLM\\SOFTWARE\\Microsoft\\Windows\\CurrentVersion\" \"{file}\" /y");
            AddLog("OK", $"💾 Backup salvo: {file}");
        }

        private void RunCreateRestorePoint()
        {
            AddLog("EXEC", "Criando ponto de restauração...");
            RunCommand("powershell", "-Command \"Checkpoint-Computer -Description 'WinOptimizer' -RestorePointType 'MODIFY_SETTINGS'\"");
            AddLog("OK", "📍 Ponto de restauração criado!");
        }

        private void RunHealthDiagnostic()
        {
            AddLog("INFO", "=== 🏥 DIAGNÓSTICO DE SAÚDE ===");
            AddLog("INFO", $"🖥️ OS: {Environment.OSVersion}");
            AddLog("INFO", $"💻 Máquina: {Environment.MachineName}");
            AddLog("INFO", $"👤 Usuário: {Environment.UserName}");
            AddLog("INFO", $"🧠 Processadores: {Environment.ProcessorCount}");
            var drives = DriveInfo.GetDrives();
            foreach (var drive in drives)
            {
                if (drive.IsReady && drive.DriveType == DriveType.Fixed)
                {
                    double freeGB = drive.AvailableFreeSpace / 1073741824.0;
                    double totalGB = drive.TotalSize / 1073741824.0;
                    AddLog("INFO", $"💽 {drive.Name}: {freeGB:F1}GB livre de {totalGB:F1}GB");
                }
            }
            AddLog("OK", "Diagnóstico concluído!");
        }

        private void RunDefenderScan()
        {
            AddLog("EXEC", "Iniciando scan do Windows Defender...");
            RunCommand("powershell", "-Command \"Start-MpScan -ScanType QuickScan\"");
            AddLog("OK", "🦠 Scan iniciado em segundo plano!");
        }

        // Privacidade
        private void RunDisableTelemetry()
        {
            SetRegistry(@"SOFTWARE\Policies\Microsoft\Windows\DataCollection", "AllowTelemetry", 0);
            AddLog("OK", "📡 Telemetria desativada!");
        }

        private void RunDisableAdvertisingID()
        {
            SetRegistry(@"Software\Microsoft\Windows\CurrentVersion\AdvertisingInfo", "Enabled", 0);
            AddLog("OK", "🎯 Advertising ID desativado!");
        }

        private void RunDisableCortana()
        {
            SetRegistry(@"SOFTWARE\Policies\Microsoft\Windows\Windows Search", "AllowCortana", 0);
            AddLog("OK", "🎤 Cortana desativada!");
        }

        private void RunDisableTimeline()
        {
            SetRegistry(@"SOFTWARE\Policies\Microsoft\Windows\System", "EnableActivityFeed", 0);
            AddLog("OK", "📅 Timeline desativada!");
        }

        // Visuais
        private void RunDarkTheme()
        {
            SetRegistry(@"Software\Microsoft\Windows\CurrentVersion\Themes\Personalize", "AppsUseLightTheme", 0);
            SetRegistry(@"Software\Microsoft\Windows\CurrentVersion\Themes\Personalize", "SystemUsesLightTheme", 0);
            AddLog("OK", "🌙 Tema escuro ativado!");
        }

        private void RunLightTheme()
        {
            SetRegistry(@"Software\Microsoft\Windows\CurrentVersion\Themes\Personalize", "AppsUseLightTheme", 1);
            SetRegistry(@"Software\Microsoft\Windows\CurrentVersion\Themes\Personalize", "SystemUsesLightTheme", 1);
            AddLog("OK", "☀️ Tema claro ativado!");
        }

        private void RunDisableTransparency()
        {
            SetRegistry(@"Software\Microsoft\Windows\CurrentVersion\Themes\Personalize", "EnableTransparency", 0);
            AddLog("OK", "🪟 Transparência desativada!");
        }

        private void RunDisableAnimations()
        {
            SetRegistry(@"Control Panel\Desktop\WindowMetrics", "MinAnimate", "0");
            AddLog("OK", "⚡ Animações desativadas!");
        }

        // Serviços
        private void StopAndDisableService(string name)
        {
            RunCommand("net", $"stop {name}");
            RunCommand("sc", $"config {name} start= disabled");
        }

        private void RunDisableDiagTrack()
        {
            StopAndDisableService("DiagTrack");
            AddLog("OK", "📊 DiagTrack desativado!");
        }

        private void RunDisableSysMain()
        {
            StopAndDisableService("SysMain");
            AddLog("OK", "💽 SysMain desativado!");
        }

        private void RunDisableSearch()
        {
            StopAndDisableService("WSearch");
            AddLog("OK", "🔍 Windows Search desativado!");
        }

        private void RunDisableXboxServices()
        {
            string[] services = { "XblAuthManager", "XblGameSave", "XboxNetApiSvc", "XboxGipSvc" };
            foreach (var s in services)
            {
                StopAndDisableService(s);
            }
            AddLog("OK", "🎮 Serviços Xbox desativados!");
        }

        // Windows Update
        private void RunCheckUpdates()
        {
            AddLog("EXEC", "Verificando atualizações...");
            RunCommand("powershell", "-Command \"(New-Object -ComObject Microsoft.Update.Session).CreateUpdateSearcher().Search('IsInstalled=0').Updates.Count\"");
            AddLog("OK", "🔍 Verificação concluída! Veja Windows Update para detalhes.");
        }

        private void RunPauseUpdates()
        {
            string date = DateTime.Now.AddDays(7).ToString("yyyy-MM-dd");
            SetRegistry(@"SOFTWARE\Microsoft\WindowsUpdate\UX\Settings", "PauseUpdatesExpiryTime", date, RegistryValueKind.String);
            AddLog("OK", $"⏸️ Atualizações pausadas até {date}");
        }

        private void RunResumeUpdates()
        {
            try
            {
                using (var key = Registry.LocalMachine.OpenSubKey(@"SOFTWARE\Microsoft\WindowsUpdate\UX\Settings", true))
                {
                    key?.DeleteValue("PauseUpdatesExpiryTime", false);
                }
            }
            catch { }
            AddLog("OK", "▶️ Atualizações retomadas!");
        }

        // WSL2
        private void RunEnableWSL()
        {
            AddLog("EXEC", "Habilitando WSL2...");
            RunCommand("wsl", "--install --no-distribution");
            AddLog("OK", "🐧 WSL2 habilitado! Reinicie o PC.");
        }

        private void RunWSLStatus()
        {
            AddLog("EXEC", "Verificando status do WSL...");
            var psi = new ProcessStartInfo
            {
                FileName = "wsl",
                Arguments = "--list --verbose",
                UseShellExecute = false,
                CreateNoWindow = true,
                RedirectStandardOutput = true
            };
            var proc = Process.Start(psi);
            string output = proc.StandardOutput.ReadToEnd();
            AddLog("INFO", output);
        }

        // Rede
        private void RunDNSCloudflare()
        {
            RunCommand("netsh", "interface ip set dns \"Ethernet\" static 1.1.1.1 primary");
            RunCommand("netsh", "interface ip add dns \"Ethernet\" 1.0.0.1 index=2");
            AddLog("OK", "☁️ DNS Cloudflare configurado!");
        }

        private void RunDNSGoogle()
        {
            RunCommand("netsh", "interface ip set dns \"Ethernet\" static 8.8.8.8 primary");
            RunCommand("netsh", "interface ip add dns \"Ethernet\" 8.8.4.4 index=2");
            AddLog("OK", "🔵 DNS Google configurado!");
        }

        private void RunResetWinsock()
        {
            RunCommand("netsh", "winsock reset");
            RunCommand("netsh", "int ip reset");
            AddLog("OK", "🔧 Winsock resetado! Reinicie o PC.");
        }

        private void RunRenewIP()
        {
            RunCommand("ipconfig", "/release");
            RunCommand("ipconfig", "/renew");
            AddLog("OK", "🔄 IP renovado!");
        }

        // Bloatwares
        private void RunRemoveXbox()
        {
            RunCommand("powershell", "-Command \"Get-AppxPackage *xbox* | Remove-AppxPackage\"");
            AddLog("OK", "🎮 Xbox Apps removidos!");
        }

        private void RunRemoveCortana()
        {
            RunCommand("powershell", "-Command \"Get-AppxPackage *cortana* | Remove-AppxPackage\"");
            AddLog("OK", "🎤 Cortana removida!");
        }

        private void RunRemoveSolitaire()
        {
            RunCommand("powershell", "-Command \"Get-AppxPackage *solitaire* | Remove-AppxPackage\"");
            AddLog("OK", "🃏 Solitaire removido!");
        }

        private void RunRemoveSkype()
        {
            RunCommand("powershell", "-Command \"Get-AppxPackage *skype* | Remove-AppxPackage\"");
            AddLog("OK", "💬 Skype removido!");
        }

        private void RunRemoveOneDrive()
        {
            RunCommand("taskkill", "/F /IM OneDrive.exe");
            string path = Path.Combine(Environment.GetEnvironmentVariable("SYSTEMROOT"), "SysWOW64", "OneDriveSetup.exe");
            if (File.Exists(path))
            {
                RunCommand(path, "/uninstall");
            }
            AddLog("OK", "☁️ OneDrive removido!");
        }

        // Perfis
        private void RunProfileGamer()
        {
            AddLog("EXEC", "Aplicando perfil Gamer...");
            RunUltimatePerformance();
            RunGameMode();
            RunHAGS();
            AddLog("OK", "🎮 Perfil GAMER aplicado!");
        }

        private void RunProfileDev()
        {
            AddLog("EXEC", "Aplicando perfil Dev...");
            InstallPackage("Git.Git", "Git");
            InstallPackage("Microsoft.VisualStudioCode", "VS Code");
            AddLog("OK", "💻 Perfil DEV aplicado!");
        }

        private void RunProfileOffice()
        {
            AddLog("EXEC", "Aplicando perfil Office...");
            RunDisableAnimations();
            RunDisableTransparency();
            AddLog("OK", "📊 Perfil OFFICE aplicado!");
        }

        // Self-Update
        private void RunCheckVersion()
        {
            AddLog("EXEC", "Verificando versão...");
            AddLog("INFO", "Versão local: 6.0.0");
            try
            {
                System.Net.WebClient client = new System.Net.WebClient();
                string remote = client.DownloadString("https://raw.githubusercontent.com/denalth/otimizador_windows/main/version.txt").Trim();
                AddLog("INFO", $"Versão remota: {remote}");
                if (string.Compare(remote, "6.0.0") > 0)
                    AddLog("WARN", $"🚀 NOVA VERSÃO DISPONÍVEL: {remote}");
                else
                    AddLog("OK", "✅ Você está na versão mais recente!");
            }
            catch (Exception ex)
            {
                AddLog("ERRO", ex.Message);
            }
        }

        private void RunOpenGitHub()
        {
            Process.Start(new ProcessStartInfo("https://github.com/denalth/otimizador_windows/releases") { UseShellExecute = true });
            AddLog("OK", "�� Página do GitHub aberta!");
        }
    }
}
