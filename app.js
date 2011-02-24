var http = require('http'),
    trans = require('./lib/transmogrify');
    server = http.createServer(trans.server),
    port = parseInt(process.argv[process.argv.length - 1]);


if(!isNaN(port)){
  server.listen(port);
}
