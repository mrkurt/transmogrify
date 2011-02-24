_ = require 'underscore'
uglify = require('./processors/uglify')
coffee = require('./processors/coffee')
url = require('url')
eco = require('eco')
fs = require('fs')
sys = require('sys')
qs = require('querystring')

exports.processors = ps = { uglify : uglify, coffee : coffee}

exports.process = process = (processors, src)->
  unless processors?
    processors = ['coffee', 'uglify']

  if typeof processors == 'string'
    processors = (p.trim() for p in processors.split(','))
  for f in processors when ps[f] && ps[f].process
    try
      src = ps[f].process(src)
    catch error
      error.processor = f
      throw error
  src

exports.render = render = (tmpl, locals)->
  tmpl = 'index' if tmpl == '/' || tmpl == ''
  template = fs.readFileSync __dirname + "/../templates/#{tmpl}.html.eco", "utf-8"
  eco.render template, locals
paths = {}
paths.GET =
  '/compile' : (req, res) ->
    res.render 'compile'
paths.POST =
  '/compile' : (req, res) ->
    post = qs.parse(req.data)
    p = req.url.query
    out = { processors: p }

    try
      out.output = process(p, post.data)
      res.writeHead 200, 'Content-Type': 'application/json'
    catch error
      out.error = {processor: error.processor, message: error.message }
      res.writeHead 500, 'Content-Type': 'application/json'

    res.end JSON.stringify(out)

exports.server = (req, res) ->
  res.render = (tmpl, locals)=>
    res.writeHead 200, 'Content-Type': 'text/html'
    res.end render tmpl, locals

  req.data = ''
  req.addListener "data", (chunk) ->
    req.data += chunk

  req.addListener "end", () ->
    req.url = url.parse(req.url)
    path = req.url.pathname
    path = "/compile" if path.trim() == '/'
    m = paths[req.method][path]
    if m && m instanceof Function
      m(req, res)
    else if m == true
      res.render path
    else
      res.writeHead 404, 'Content-Type': 'text/plain'
      res.end "four oh four! (#{req.method} #{req.url.pathname})"
