var http = require('http'),
    trans = require('./lib/transmogrify.js');

http.createServer(trans.server).listen(process.env.PORT || 8080);
