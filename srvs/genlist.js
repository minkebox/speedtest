#! /usr/bin/nodejs

const https = require('https');
const parser = require('xml2json');

// 'https://www.speedtest.net/speedtest-servers-static.php'

const req = https.request({
  method: 'GET',
  hostname: 'www.speedtest.net',
  port: 443,
  path: '/speedtest-servers-static.php'
}, res => {
  let data = '';
  res.on('data', chunk => {
    data += chunk;
  });
  res.on('end', () => {
    const kv = {};
    data = JSON.parse(parser.toJson(data));
    const servers = data.settings.servers.server;
    servers.forEach(server => {
      const key = `${server.country}/${server.name}`;
      if (!kv[key]) {
       kv[key] = server.id;
      }
    });
    const keys = Object.keys(kv);
    keys.sort();
    const entries = [];
    entries.push({ name: 'Auto select', value: '0' });
    keys.forEach(key => {
      entries.push({ name: key, value: kv[key] });
    });
    console.log(JSON.stringify(entries));
  });
});
req.end();
