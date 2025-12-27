# Autoria: @denalth
# utils.ps1 - Modulo Utilitario v5.0
# Funcoes de suporte, logging e seguranca

# === SISTEMA DE LOG PERSISTENTE ===
$global:LogDir = "$env:USERPROFILE\WindowsOptimizerLogs"
$global:LogFile = $null

function Initialize-Log {
    param([string]$baseDir = $global:LogDir)
    
    if (-not (Test-Path $baseDir)) {
        New-Item -ItemType Directory -Path $baseDir -Force | Out-Null
    }
    
    $timestamp = Get-Date -Format "yyyyMMdd"
    $global:LogFile = Join-Path $baseDir "optimizer_$timestamp.log"
    
    if (-not (Test-Path $global:LogFile)) {
        "=== Windows Optimizer Log - $(Get-Date) ===" | Out-File $global:LogFile -Encoding UTF8
    }
    
    return $global:LogFile
}

function Write-Log {
    param([string]$Message, [string]$Type = "INFO")
    
    $timestamp = Get-Date -Format "HH:mm:ss"
    $entry = "[$timestamp][$Type] $Message"
    
    # Console
    $color = switch ($Type) {
        "INFO" { "Cyan" }
        "OK" { "Green" }
        "WARN" { "Yellow" }
        "ERROR" { "Red" }
        default { "White" }
    }
    Write-Host " $entry" -ForegroundColor $color
    
    # Arquivo persistente
    if ($global:LogFile -and (Test-Path $global:LogFile -IsValid)) {
        $entry | Out-File $global:LogFile -Encoding UTF8 -Append
    }
}

function Log-Info { param([string]$msg) Write-Log -Message $msg -Type "INFO" }
function Log-Success { param([string]$msg) Write-Log -Message $msg -Type "OK" }
function Log-Warning { param([string]$msg) Write-Log -Message $msg -Type "WARN" }
function Log-Error { param([string]$msg) Write-Log -Message $msg -Type "ERROR" }

# === FUNCOES DE INTERACAO ===
function Confirm-YesNo {
    param([string]$Prompt)
    $response = Read-Host " $Prompt (S/N)"
    return ($response -eq 'S' -or $response -eq 's' -or $response -eq 'Y' -or $response -eq 'y')
}

function Run-Safe {
    param(
        [scriptblock]$action,
        [string]$description = "Acao"
    )
    
    try {
        Log-Info "Executando: $description"
        & $action
        Log-Success "$description concluido."
    } catch {
        Log-Error "Falha em ${description}: $_"
    }
}

# === VERIFICACOES DE AMBIENTE ===
function Test-IsAdmin {
    $principal = New-Object Security.Principal.WindowsPrincipal([Security.Principal.WindowsIdentity]::GetCurrent())
    return $principal.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
}

function Test-WingetAvailable {
    return (Get-Command winget -ErrorAction SilentlyContinue) -ne $null
}

function Get-WindowsVersion {
    $os = Get-CimInstance Win32_OperatingSystem
    return "$($os.Caption) Build $($os.BuildNumber)"
}

# === INICIALIZACAO GIT (LEGADO) ===
function Init-GitRepo {
    param([string]$scriptDir)
    
    if (-not (Test-Path (Join-Path $scriptDir ".git"))) {
        Log-Info "Inicializando repositorio Git..."
        git init $scriptDir
        Log-Success "Repositorio Git criado."
    } else {
        Log-Info "Repositorio Git ja existe."
    }
}
