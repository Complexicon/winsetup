const get = (url, onProgress) => new Promise(resolve => {
    require(url.startsWith('https') ? 'https': 'http').get(url, r => {
        if(r.statusCode === 301 || r.statusCode === 302) {
            return get(r.headers.location, onProgress).then(resolve)
        }

        let buffer = [];
        const len = r.headers['content-length'];
        r.on('data', async(d) => {
            buffer.push(d);
            onProgress && await onProgress(buffer.reduce((sum, buf) => sum + buf.length, 0) / len);
        });
        r.on('end', () => resolve({ data: Buffer.concat(buffer), type: r.headers['content-type']}));
    });
});

module.exports = get;