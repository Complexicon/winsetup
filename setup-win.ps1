# test script

if (-Not ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] 'Administrator')) {
 if ([int](Get-CimInstance -Class Win32_OperatingSystem | Select-Object -ExpandProperty BuildNumber) -ge 6000) {
  $CommandLine = "-Command `"" + $MyInvocation.MyCommand + "`""
  Start-Process -FilePath PowerShell.exe -Verb Runas -ArgumentList $CommandLine
  Exit
 }
}

$SetupDir = (gi $env:temp).fullname + "\setup-win";

md $SetupDir -ErrorAction SilentlyContinue
cd $SetupDir

$ProgressPreference = 'SilentlyContinue'

Write-Host "Downloading VC++14...";
Invoke-WebRequest -Uri "https://aka.ms/Microsoft.VCLibs.x64.14.00.Desktop.appx" -OutFile VCLibs.appx

Write-Host "Downloading Microsoft XAML UI 2.7...";
Invoke-WebRequest -Uri "https://www.nuget.org/api/v2/package/Microsoft.UI.Xaml/2.7" -OutFile XamlLib.zip

Write-Host "Downloading Winget...";
Invoke-WebRequest -Uri "https://aka.ms/getwinget" -OutFile winget.msixbundle

Expand-Archive ".\XamlLib.zip" -DestinationPath ".\XamlUnzipped"

Write-Host "Installing VC++14...";
Add-AppxPackage -Path ".\VCLibs.appx"  -ErrorAction SilentlyContinue

Write-Host "Installing Microsoft XAML UI 2.7...";
Add-AppxPackage -Path ".\XamlUnzipped\tools\AppX\x64\Release\Microsoft.UI.Xaml.2.7.appx" -ErrorAction SilentlyContinue

Write-Host "Installing Winget...";
Add-AppxProvisionedPackage -Online -PackagePath ".\winget.msixbundle" -SkipLicense

cd ..

Remove-Item -Recurse -Force $SetupDir

winget install Microsoft.WindowsTerminal --accept-source-agreements

wt new-tab powershell.exe -Command "Set-ExecutionPolicy Bypass -Scope Process -Force\;iex ((New-Object System.Net.WebClient).DownloadString('https://raw.githubusercontent.com/Complexicon/winsetup/main/winget-packages.ps1'))"
