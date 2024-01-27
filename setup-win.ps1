# test script

if (-Not ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] 'Administrator')) {
 if ([int](Get-CimInstance -Class Win32_OperatingSystem | Select-Object -ExpandProperty BuildNumber) -ge 6000) {
  $CommandLine = "-Command `"" + $MyInvocation.MyCommand + "`""
  Start-Process -FilePath PowerShell.exe -Verb Runas -ArgumentList $CommandLine
  Exit
 }
}

function Update-EnvironmentVariables {
  foreach($level in "Machine","User") {
    [Environment]::GetEnvironmentVariables($level).GetEnumerator() | % {
        # For Path variables, append the new values, if they're not already in there
        if($_.Name -match 'Path$') {
          $_.Value = ($((Get-Content "Env:$($_.Name)") + ";$($_.Value)") -split ';' | Select -unique) -join ';'
        }
        $_
    } | Set-Content -Path { "Env:$($_.Name)" }
  }
}

$SetupDir = (gi $env:temp).fullname + "\setup-win";

md $SetupDir -ErrorAction SilentlyContinue
cd $SetupDir

$ProgressPreference = 'SilentlyContinue'

Write-Host "Downloading and Installing VC++14...";
#Invoke-WebRequest -Uri "https://aka.ms/Microsoft.VCLibs.x64.14.00.Desktop.appx" -OutFile VCLibs.appx
Add-AppxPackage "https://aka.ms/Microsoft.VCLibs.x64.14.00.Desktop.appx"

Write-Host "Downloading and Installing Microsoft XAML UI 2.7...";
Invoke-WebRequest -Uri "https://www.nuget.org/api/v2/package/Microsoft.UI.Xaml/2.7" -OutFile XamlLib.zip
Expand-Archive ".\XamlLib.zip" -DestinationPath ".\XamlUnzipped"
Add-AppxPackage ".\XamlUnzipped\tools\AppX\x64\Release\Microsoft.UI.Xaml.2.7.appx"

Write-Host "Downloading and Installing Winget...";
Invoke-WebRequest -Uri "https://github.com/microsoft/winget-cli/releases/download/v1.3.2691/7bcb1a0ab33340daa57fa5b81faec616_License1.xml" -OutFile License.xml
Invoke-WebRequest -Uri "https://aka.ms/getwinget" -OutFile winget.msixbundle

Add-AppxPackage winget.msixbundle
Add-AppxProvisionedPackage -Online -PackagePath ".\winget.msixbundle" -LicensePath ".\License.xml" # enable license

#TAKEOWN /F "C:\Program Files\WindowsApps\Microsoft.DesktopAppInstaller_1.19.10173.0_x64__8wekyb3d8bbwe" /R /A /D J # todo internationalize
#ICACLS "C:\Program Files\WindowsApps\Microsoft.DesktopAppInstaller_1.19.10173.0_x64__8wekyb3d8bbwe" /grant Administratoren:F /T # todo internationalize

#fixup path
#$ResolveWingetPath = Resolve-Path "C:\Program Files\WindowsApps\Microsoft.DesktopAppInstaller_*_x64__8wekyb3d8bbwe"
#    if ($ResolveWingetPath){
#           $WingetPath = $ResolveWingetPath[-1].Path
#    }
#$ENV:PATH += ";$WingetPath"

cd ..

Remove-Item -Recurse -Force $SetupDir

Update-EnvironmentVariables

((New-Object System.Net.WebClient).DownloadString('https://raw.githubusercontent.com/Complexicon/winsetup/main/winget-settings.json')) | Set-Content (($env:localappdata) + '\Packages\Microsoft.DesktopAppInstaller_8wekyb3d8bbwe\LocalState\settings.json')

winget install Microsoft.WindowsTerminal --accept-source-agreements
# commented out. newer builds of windows terminal break with older windows releases e.g. ltsc 2021
#wt new-tab powershell.exe -Command "Set-ExecutionPolicy Bypass -Scope Process -Force\;iex ((New-Object System.Net.WebClient).DownloadString('https://raw.githubusercontent.com/Complexicon/winsetup/main/winget-packages.ps1'))"
iex ((New-Object System.Net.WebClient).DownloadString('https://raw.githubusercontent.com/Complexicon/winsetup/main/winget-packages.ps1')
