const dl = await requireCloud('cloudInstaller/dl.js');
const child = await requireCloud('cloudInstaller/child_process.js');
const fs = require('fs/promises');

function progressBar(text) {
    let prevProgress = 0;
    return async(progress) => {
        if(prevProgress === Math.trunc(progress * 100)) return;

        if(progress === 1) {
            process.stdout.clearLine();
            process.stdout.write('✓ - ' + text +'\n')
        }

        process.stdout.clearLine();
        process.stdout.write(Math.trunc(progress * 100) + '% - ' + text + '\r');
        prevProgress = Math.trunc(progress * 100);
    }
}

process.stdin.setRawMode(true);

const vclibs = await dl('https://aka.ms/Microsoft.VCLibs.x64.14.00.Desktop.appx', progressBar('VC++14'));

const xaml = await dl('https://www.nuget.org/api/v2/package/Microsoft.UI.Xaml/2.7', progressBar('Microsoft XAML UI 2.7'));

const license = await dl('https://github.com/microsoft/winget-cli/releases/download/v1.3.2691/7bcb1a0ab33340daa57fa5b81faec616_License1.xml', progressBar('Winget License'));
const winget = await dl('https://aka.ms/getwinget', progressBar('Winget'));

await Promise.all([
    fs.writeFile('vclibs.appx', vclibs.data),
    fs.writeFile('xaml.zip', xaml.data),
    fs.writeFile('license.xml', license.data),
    fs.writeFile('winget.msixbundle', winget.data)
]);

await child.powershell('Expand-Archive ".\\xaml.zip" -DestinationPath ".\\XamlUnzipped"')

console.log('installing winget...');
const installResult = await child.powershell(
    'Add-AppxProvisionedPackage -Online -PackagePath ".\\winget.msixbundle" -LicensePath ".\\license.xml" -DependencyPackagePath ".\\vclibs.appx",".\\XamlUnzipped\\tools\\AppX\\x64\\Release\\Microsoft.UI.Xaml.2.7.appx"'
);

console.log(installResult);

process.stdin.on('data', () => process.exit());