require.paths.unshift __dirname + '/lib'

{print} = require 'sys'
{spawn} = require 'child_process'

build = (cb)->
  coffee = spawn 'coffee', ['-c', '-o', 'lib', 'src']
  coffee.stdout.on 'data', (data) -> print data.toString()
  coffee.stderr.on 'data', (data) -> print data.toString()
  if cb?
    coffee.on 'exit', cb

task 'build', 'Build lib/ from src/', ->
  build()

task 'test', 'Run tests', ->
  build ()->
    process.chdir __dirname
    {reporters} = require 'nodeunit'
    reporters.default.run ['test']

option '-p', '--port [NUMBER]', 'port for server to listen on'
task 'server', 'Run server', (options)->
  build ()->
    http = require('http')
    trans = require('transmogrify')
    p = options.port or 8080
    http.createServer(trans.server).listen(p)
