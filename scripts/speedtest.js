#! /usr/bin/node

const fs = require('fs');
const speedTest = require('/usr/lib/node_modules/speedtest-net');
const config = {};
if (process.env.SERVER_ID) {
  config.serverId = process.env.SERVER_ID;
}
//const config = {
//  serverId: '17846'
//};
const csv = `${__dirname}/../data/result.csv`;

const test = speedTest(config);
test.on('data', (data) => {
  // timestamp,ping,download,upload
  const result = `${Date.now()},${data.server.ping},${data.speeds.download},${data.speeds.upload}\n`;
  console.log(result);
  fs.appendFileSync(csv, result);
});
