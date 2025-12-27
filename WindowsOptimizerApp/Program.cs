// Autoria: @denalth
// Program.cs - Windows Optimizer v6.0.4
// Aplicativo nativo C# com Caminhos Dinamicos (Portabilidade)

using System;
using System.Drawing;
using System.Windows.Forms;
using System.Diagnostics;
using System.IO;

class SplashScreen : Form
{
    private Label lblTitle;
    private Label lblVersion;
    private Label lblLoading;
    private ProgressBar progressBar;
    private Timer timer;
    private int progress = 0;

    public SplashScreen()
    {
        this.Text = "";
        this.Size = new Size(400, 250);
        this.StartPosition = FormStartPosition.CenterScreen;
        this.FormBorderStyle = FormBorderStyle.None;
        this.BackColor = Color.FromArgb(18, 18, 18);

        lblTitle = new Label { Text = "WINDOWS OPTIMIZER", Font = new Font("Segoe UI", 22, FontStyle.Bold), ForeColor = Color.White, AutoSize = true, Location = new Point(50, 50) };
        lblVersion = new Label { Text = "v6.0.4 by @denalth", Font = new Font("Segoe UI", 10, FontStyle.Italic), ForeColor = Color.FromArgb(0, 120, 215), AutoSize = true, Location = new Point(130, 95) };
        lblLoading = new Label { Text = "Carregando modulos...", Font = new Font("Segoe UI", 9), ForeColor = Color.Gray, AutoSize = true, Location = new Point(135, 150) };
        progressBar = new ProgressBar { Location = new Point(50, 180), Size = new Size(300, 20), Style = ProgressBarStyle.Continuous, Value = 0 };

        this.Controls.Add(lblTitle);
        this.Controls.Add(lblVersion);
        this.Controls.Add(lblLoading);
        this.Controls.Add(progressBar);

        timer = new Timer { Interval = 30 };
        timer.Tick += (s, e) => {
            progress += 5;
            progressBar.Value = Math.Min(progress, 100);
            if (progress >= 100) { timer.Stop(); this.Close(); }
        };
        timer.Start();
    }
}

class MainForm : Form
{
    public MainForm()
    {
        this.Text = "Windows Optimizer v6.0.4";
        this.Size = new Size(450, 350);
        this.StartPosition = FormStartPosition.CenterScreen;
        this.FormBorderStyle = FormBorderStyle.FixedSingle;
        this.MaximizeBox = false;
        this.BackColor = Color.FromArgb(30, 30, 30);

        Label lblTitle = new Label { Text = "Windows Optimizer", Font = new Font("Segoe UI", 24, FontStyle.Bold), ForeColor = Color.White, AutoSize = true, Location = new Point(80, 40) };
        this.Controls.Add(lblTitle);

        Button btnStart = new Button {
            Text = "ABRIR INTERFACE DE OTIMIZACAO",
            Size = new Size(350, 100),
            Location = new Point(50, 130),
            FlatStyle = FlatStyle.Flat,
            BackColor = Color.FromArgb(0, 120, 215),
            ForeColor = Color.White,
            Font = new Font("Segoe UI", 12, FontStyle.Bold),
            Cursor = Cursors.Hand
        };
        btnStart.FlatAppearance.BorderSize = 0;
        btnStart.Click += btnStart_Click;
        this.Controls.Add(btnStart);

        Label lblFooter = new Label { Text = "Powered by @denalth | v6.0.4", Font = new Font("Segoe UI", 8), ForeColor = Color.Gray, AutoSize = true, Location = new Point(150, 280) };
        this.Controls.Add(lblFooter);
    }

    private void btnStart_Click(object sender, EventArgs e)
    {
        // CAMINHO DINAMICO: BaseDirectory pega a pasta onde o .exe esta
        string baseDir = AppDomain.CurrentDomain.BaseDirectory;
        string scriptPath = Path.Combine(baseDir, "Lancar_GUI.ps1");

        if (!File.Exists(scriptPath)) {
            MessageBox.Show("Script Lancar_GUI.ps1 nao encontrado no diretorio: " + baseDir, "Erro de Localizacao");
            return;
        }

        ProcessStartInfo psi = new ProcessStartInfo {
            FileName = "powershell.exe",
            Arguments = "-WindowStyle Hidden -NoProfile -ExecutionPolicy Bypass -File \"" + scriptPath + "\"",
            Verb = "runas",
            UseShellExecute = true,
            WindowStyle = ProcessWindowStyle.Hidden
        };

        try {
            Process.Start(psi);
            this.WindowState = FormWindowState.Minimized;
        } catch (Exception ex) {
            MessageBox.Show("Erro ao iniciar o processo: " + ex.Message, "Erro Critico");
        }
    }
}

class Program
{
    [STAThread]
    static void Main()
    {
        Application.EnableVisualStyles();
        Application.SetCompatibleTextRenderingDefault(false);
        Application.Run(new SplashScreen());
        Application.Run(new MainForm());
    }
}







