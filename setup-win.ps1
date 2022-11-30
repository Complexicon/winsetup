# test script

function Test-Administrator  
{  
    [OutputType([bool])]
    param()
    process {
        [Security.Principal.WindowsPrincipal]$user = [Security.Principal.WindowsIdentity]::GetCurrent();
        return $user.IsInRole([Security.Principal.WindowsBuiltinRole]::Administrator);
    }
}

if(-not (Test-Administrator))
{
    echo This script must be executed as Administrator
    pause
    exit 1;
}

cd (gi $env:temp).fullname

Invoke-WebRequest -Uri "https://aka.ms/Microsoft.VCLibs.x64.14.00.Desktop.appx" -OutFile VCLibs.appx
Invoke-WebRequest -Uri "https://www.nuget.org/api/v2/package/Microsoft.UI.Xaml/2.7" -OutFile XamlLib.zip
Invoke-WebRequest -Uri "https://github.com/microsoft/winget-cli/releases/download/v1.3.2691/Microsoft.DesktopAppInstaller_8wekyb3d8bbwe.msixbundle" -OutFile winget.appx
Invoke-WebRequest -Uri "https://github.com/microsoft/winget-cli/releases/download/v1.3.2691/7bcb1a0ab33340daa57fa5b81faec616_License1.xml" -OutFile License.xml

Expand-Archive ".\XamlLib.zip" -DestinationPath ".\XamlUnzipped"

pause
