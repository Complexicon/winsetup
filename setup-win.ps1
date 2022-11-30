# test script

if (-Not ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] 'Administrator')) {
 if ([int](Get-CimInstance -Class Win32_OperatingSystem | Select-Object -ExpandProperty BuildNumber) -ge 6000) {
  $CommandLine = "-Command `"" + $MyInvocation.MyCommand + "`""
  Start-Process -FilePath PowerShell.exe -Verb Runas -ArgumentList $CommandLine
  Exit
 }
}

cd (gi $env:temp).fullname

Invoke-WebRequest -Uri "https://aka.ms/Microsoft.VCLibs.x64.14.00.Desktop.appx" -OutFile VCLibs.appx
Invoke-WebRequest -Uri "https://www.nuget.org/api/v2/package/Microsoft.UI.Xaml/2.7" -OutFile XamlLib.zip
Invoke-WebRequest -Uri "https://github.com/microsoft/winget-cli/releases/download/v1.3.2691/Microsoft.DesktopAppInstaller_8wekyb3d8bbwe.msixbundle" -OutFile winget.appx
Invoke-WebRequest -Uri "https://github.com/microsoft/winget-cli/releases/download/v1.3.2691/7bcb1a0ab33340daa57fa5b81faec616_License1.xml" -OutFile License.xml

Expand-Archive ".\XamlLib.zip" -DestinationPath ".\XamlUnzipped"

pause
