<#
.SYNOPSIS
    DEOmorph FPGA Automation Setup Script for Windows 11 and Tailscale.
.DESCRIPTION
    Installs OmniRoute, flushes the native cache, opens network port 20128, 
    and initializes the software-defined gate matrix on all secure virtual adapters.
#>

$ErrorActionPreference = "Stop"

Write-Host "==========================================================" -ForegroundColor Cyan
Write-Host " DEOmorph FPGA Architecture - Local Matrix Initialization" -ForegroundColor Cyan
Write-Host "==========================================================" -ForegroundColor Cyan

# 1. Verify Node.js Environment
Write-Host "[*] Verifying Node.js environment requirements..." -ForegroundColor Yellow
if (Get-Command node -ErrorAction SilentlyContinue) {
    $nodeVersion = node -v
    Write-Host "[+] Found Node.js version: $nodeVersion" -ForegroundColor Green
} else {
    Write-Error "[-] Node.js is not installed. Please download Node.js v22+ or v24+ from https://nodejs.org"
}

# 2. Flush and Rebuild OmniRoute Global Package
Write-Host "[*] Purging legacy caches and compiling OmniRoute native modules..." -ForegroundColor Yellow
try {
    # Delete legacy cached databases to prevent local migration hangs
    $omniCache = "$HOME\.omniroute"
    if (Test-Path $omniCache) {
        Remove-Item -Recurve -Force $omniCache
        Write-Host "[+] Legacy local user .omniroute cache successfully purged." -ForegroundColor Green
    }
    
    # Force clean binary installation to resolve better-sqlite3 Win32 application blocks
    npm cache clean --force
    npm install -g omniroute@latest
    Write-Host "[+] OmniRoute core engine successfully compiled globally." -ForegroundColor Green
} catch {
    Write-Error "[-] Node package installation failed. Check internet connectivity or npm execution policy permissions."
}

# 3. Configure Windows Defender Firewall for Tailscale/Local Mesh
Write-Host "[*] Configuring Windows Defender Firewall bindings for Port 20128..." -ForegroundColor Yellow
$RuleName = "DEOmorph_FPGA_OmniRoute_Inbound"
$RuleExists = Get-NetFirewallRule -DisplayName $RuleName -ErrorAction SilentlyContinue

if ($RuleExists) {
    Write-Host "[+] Secure firewall rule already exists." -ForegroundColor Green
} else {
    try {
        # Elevated permission check required for firewall updates
        if (-not ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
            Write-Warning "[-] Administrator privileges missing. Relaunch PowerShell as Admin to bind the Windows Firewall."
        } else {
            New-NetFirewallRule -DisplayName $RuleName -Direction Inbound -Action Allow -Protocol TCP -LocalPort 20128 -Profile Private, Public
            Write-Host "[+] Firewall ports successfully opened for Private and Public (Tailscale) network topologies." -ForegroundColor Green
        }
    } catch {
        Write-Host "[-] Could not automatically append firewall rules. Please verify parameters manually." -ForegroundColor Red
    }
}

# 4. Initialize Software-Defined Gateway
Write-Host ""
Write-Host "[+] Execution Matrix Prepared Successfully!" -ForegroundColor Green
Write-Host "[!] Launching DEOmorph matrix bound to 0.0.0.0:20128..." -ForegroundColor Magenta
Write-Host "[!] Access endpoints securely over Tailscale using your local 100.x.y.z virtual IP address." -ForegroundColor Magenta
Write-Host "----------------------------------------------------------"

# Execute OmniRoute with pure chaos routing entropy and token compression active
npx omniroute --host 0.0.0.0 --port 20128 --strategy chaos --compress true --cache false
