function createCloudRequire(baseURL) {

    let handler;
    if(baseURL.startsWith('https')) {
        handler = require('https');
    } else if(baseURL.startsWith('http')) {
        handler = require('http');
    } else throw new Error('unknown scheme');

    const cloudCache = {
        'cloud_helper': { exports: createCloudRequire }
    };

    const AsyncFunction = Object.getPrototypeOf(async function(){}).constructor;

    const theRequire = (modulePath) => new Promise(resolve => {

        if(cloudCache[modulePath]) return resolve(cloudCache[modulePath].exports);

        handler.get(new URL(modulePath, baseURL), r => {
            let buffer = [];
            r.on('data', d => buffer.push(d));
            r.on('end', () => {
                const cloudModule = { exports: {} };
                cloudCache[modulePath] = cloudModule;
                new AsyncFunction('requireCloud', 'require', 'module', Buffer.concat(buffer).toString('utf8'))(theRequire, require, cloudModule).then(() => {
                    resolve(cloudModule.exports);
                });
            });
        })
    });

    return theRequire;
}

createCloudRequire(process.env.CLOUD_SCRIPT_HOST)('cloudInstaller/main.js');