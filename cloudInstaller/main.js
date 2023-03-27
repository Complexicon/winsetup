const child = await requireCloud('cloudInstaller/child_process.js');

const wingetTest = await child.exec('winget -v'); 

console.log('has winget:', wingetTest[1].error === null ? wingetTest[0] : 'no');

if(true) {
    console.log('installing winget...');
    await requireCloud('cloudInstaller/install_winget.js');
}