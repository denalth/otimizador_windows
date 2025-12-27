using System;
using System.Drawing;
using System.Windows.Forms;
using System.Diagnostics;
using System.IO;

namespace SupremeOptimizer
{
    public class MainForm : Form
    {
        private Button btnStart;
        private Label lblTitle;
        private Label lblSubTitle;
        private Label lblFooter;
        private Panel headerPanel;

        public MainForm()
        {
            // Configurações da Janela
            this.Text = "Supreme Optimizer v4.0 - @denalth";
            this.Size = new Size(450, 350);
            this.BackColor = Color.FromArgb(20, 20, 25);
            this.FormBorderStyle = FormBorderStyle.FixedSingle;
            this.StartPosition = FormStartPosition.CenterScreen;
            this.MaximizeBox = false;

            // Header Panel
            headerPanel = new Panel();
            headerPanel.Dock = DockStyle.Top;
            headerPanel.Height = 100;
            headerPanel.BackColor = Color.FromArgb(30, 30, 35);
            this.Controls.Add(headerPanel);

            // Título
            lblTitle = new Label();
            lblTitle.Text = "SUPREME OPTIMIZER";
            lblTitle.ForeColor = Color.Cyan;
            lblTitle.Font = new Font("Segoe UI", 20, FontStyle.Bold);
            lblTitle.TextAlign = ContentAlignment.MiddleCenter;
            lblTitle.Dock = DockStyle.Top;
            lblTitle.Height = 60;
            headerPanel.Controls.Add(lblTitle);

            // Subtítulo
            lblSubTitle = new Label();
            lblSubTitle.Text = "A Evolução do seu Windows começa aqui.";
            lblSubTitle.ForeColor = Color.Gray;
            lblSubTitle.Font = new Font("Segoe UI", 10);
            lblSubTitle.TextAlign = ContentAlignment.MiddleCenter;
            lblSubTitle.Dock = DockStyle.Top;
            lblSubTitle.Height = 30;
            headerPanel.Controls.Add(lblSubTitle);

            // Botão Principal
            btnStart = new Button();
            btnStart.Text = "ABRIR INTERFACE DE OTIMIZAÇÃO";
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
            lblFooter.Text = "Assinado Digitalmente por: @denalth";
            lblFooter.ForeColor = Color.DarkGray;
            lblFooter.Font = new Font("Segoe UI", 9, FontStyle.Italic);
            lblFooter.TextAlign = ContentAlignment.MiddleCenter;
            lblFooter.Dock = DockStyle.Bottom;
            lblFooter.Height = 50;
            this.Controls.Add(lblFooter);
        }

        private void btnStart_Click(object sender, EventArgs e)
        {
            // Procurar o script na pasta do F: (onde estão seus módulos)
            string scriptPath = @"F:\.Antigravity\Otimizador Windows\Lancar_GUI.ps1";

            if (File.Exists(scriptPath))
            {
                ProcessStartInfo psi = new ProcessStartInfo();
                psi.FileName = "powershell.exe";
                psi.Arguments = "-NoProfile -ExecutionPolicy Bypass -File \"" + scriptPath + "\"";
                psi.UseShellExecute = true;
                psi.Verb = "runas"; // Solicita privilégios de Admin

                try {
                    Process.Start(psi);
                    this.WindowState = FormWindowState.Minimized; // Minimiza o app enquanto o motor roda
                } catch (Exception ex) {
                    MessageBox.Show("Erro ao iniciar motor: " + ex.Message, "Erro de Lançamento", MessageBoxButtons.OK, MessageBoxIcon.Error);
                }
            }
            else
            {
                MessageBox.Show("Motor (.ps1) não encontrado no caminho:\n" + scriptPath, "Arquivo Ausente", MessageBoxButtons.OK, MessageBoxIcon.Warning);
            }
        }

        [STAThread]
        static void Main()
        {
            Application.EnableVisualStyles();
            Application.SetCompatibleTextRenderingDefault(false);
            Application.Run(new MainForm());
        }
    }
}

