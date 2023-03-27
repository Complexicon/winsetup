const childProcess = require('child_process');

module.exports = {
    exec(command) {
        return new Promise(resolve => childProcess.exec(command, { shell: 'cmd.exe', windowsHide: false }, (error, stdout, stderr) => resolve([stdout, { error, stderr }])));
    },
    powershell(command) {
        return new Promise(resolve => childProcess.exec(command, { shell: 'powershell.exe', windowsHide: false }, (error, stdout, stderr) => resolve([stdout, { error, stderr }])));
    },
    execUser(command) {
        return new Promise(resolve => childProcess.exec('runas /trustlevel:0x20000 ("cmd /C ' + command +'")', { shell: 'powershell.exe', windowsHide: false }, (error, stdout, stderr) => resolve([stdout, { error, stderr }])));
    },
    powershellUser(command) {
        return new Promise(resolve => childProcess.exec('runas /trustlevel:0x20000 ("' + command +'")', { shell: 'powershell.exe', windowsHide: false }, (error, stdout, stderr) => resolve([stdout, { error, stderr }])));
    }
}