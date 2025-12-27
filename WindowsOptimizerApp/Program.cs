// Autoria: @denalth
// Program.cs - Windows Optimizer v5.1 (Visual Polish)
// Aplicativo nativo C# com Splash Screen animada

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

        // Titulo
        lblTitle = new Label();
        lblTitle.Text = "WINDOWS OPTIMIZER";
        lblTitle.Font = new Font("Segoe UI", 22, FontStyle.Bold);
        lblTitle.ForeColor = Color.White;
        lblTitle.AutoSize = true;
        lblTitle.Location = new Point(50, 50);
        this.Controls.Add(lblTitle);

        // Versao
        lblVersion = new Label();
        lblVersion.Text = "v5.1 by @denalth";
        lblVersion.Font = new Font("Segoe UI", 10, FontStyle.Italic);
        lblVersion.ForeColor = Color.FromArgb(0, 120, 215);
        lblVersion.AutoSize = true;
        lblVersion.Location = new Point(130, 95);
        this.Controls.Add(lblVersion);

        // Loading
        lblLoading = new Label();
        lblLoading.Text = "Carregando modulos...";
        lblLoading.Font = new Font("Segoe UI", 9);
        lblLoading.ForeColor = Color.Gray;
        lblLoading.AutoSize = true;
        lblLoading.Location = new Point(135, 150);
        this.Controls.Add(lblLoading);

        // Progress Bar
        progressBar = new ProgressBar();
        progressBar.Location = new Point(50, 180);
        progressBar.Size = new Size(300, 20);
        progressBar.Style = ProgressBarStyle.Continuous;
        progressBar.Value = 0;
        this.Controls.Add(progressBar);

        // Timer para animacao
        timer = new Timer();
        timer.Interval = 30;
        timer.Tick += Timer_Tick;
        timer.Start();
    }

    private void Timer_Tick(object sender, EventArgs e)
    {
        progress += 2;
        progressBar.Value = Math.Min(progress, 100);

        if (progress >= 50) lblLoading.Text = "Inicializando interface...";
        if (progress >= 80) lblLoading.Text = "Quase pronto...";

        if (progress >= 100)
        {
            timer.Stop();
            this.Close();
        }
    }
}

class MainForm : Form
{
    private Button btnStart;
    private Label lblTitle;
    private Label lblFooter;

    public MainForm()
    {
        this.Text = "Windows Optimizer v5.1";
        this.Size = new Size(450, 350);
        this.StartPosition = FormStartPosition.CenterScreen;
        this.FormBorderStyle = FormBorderStyle.FixedSingle;
        this.MaximizeBox = false;
        this.BackColor = Color.FromArgb(30, 30, 30);

        // Titulo
        lblTitle = new Label();
        lblTitle.Text = "Windows Optimizer";
        lblTitle.Font = new Font("Segoe UI", 24, FontStyle.Bold);
        lblTitle.ForeColor = Color.White;
        lblTitle.AutoSize = true;
        lblTitle.Location = new Point(80, 40);
        this.Controls.Add(lblTitle);

        // Botao Principal
        btnStart = new Button();
        btnStart.Text = "ABRIR INTERFACE DE OTIMIZACAO";
        btnStart.Size = new Size(350, 60);
        btnStart.Location = new Point(50, 150);
        btnStart.FlatStyle = FlatStyle.Flat;
        btnStart.BackColor = Color.FromArgb(0, 120, 215);
        btnStart.ForeColor = Color.White;
        btnStart.Font = new Font("Segoe UI", 12, FontStyle.Bold);
        btnStart.Cursor = Cursors.Hand;
        btnStart.FlatAppearance.BorderSize = 0;
        btnStart.Click += new EventHandler(btnStart_Click);
        this.Controls.Add(btnStart);

        // Footer
        lblFooter = new Label();
        lblFooter.Text = "Powered by @denalth | v5.1";
        lblFooter.Font = new Font("Segoe UI", 8);
        lblFooter.ForeColor = Color.Gray;
        lblFooter.AutoSize = true;
        lblFooter.Location = new Point(150, 280);
        this.Controls.Add(lblFooter);
    }

    private void btnStart_Click(object sender, EventArgs e)
    {
        string scriptPath = @"F:\.Antigravity\Otimizador Windows\Lancar_GUI.ps1";

        if (!File.Exists(scriptPath))
        {
            MessageBox.Show("Script nao encontrado: " + scriptPath, "Erro", MessageBoxButtons.OK, MessageBoxIcon.Error);
            return;
        }

        ProcessStartInfo psi = new ProcessStartInfo();
        psi.FileName = "powershell.exe";
        psi.Arguments = "-NoProfile -ExecutionPolicy Bypass -File \"" + scriptPath + "\"";
        psi.Verb = "runas";
        psi.UseShellExecute = true;

        try
        {
            Process.Start(psi);
            this.WindowState = FormWindowState.Minimized;
        }
        catch (Exception ex)
        {
            MessageBox.Show("Erro ao iniciar: " + ex.Message, "Erro", MessageBoxButtons.OK, MessageBoxIcon.Error);
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

        // Exibir Splash Screen
        SplashScreen splash = new SplashScreen();
        Application.Run(splash);

        // Depois exibir a janela principal
        Application.Run(new MainForm());
    }
}



