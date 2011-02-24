sys = require "sys"
fs  = require "fs"

trans = require "transmogrify"

module.exports =
  "load processors": (test) ->
    test.ok trans.processors.coffee
    test.ok trans.processors.uglify
    test.done()

  "uglify js": (test) ->
    js = "var lib = function(){ var asdf = 'jklm'; }();"
    u = trans.processors.uglify.process js
    test.equal 'var lib=function(){var a="jklm"}()', u
    test.done()

  "uglify invalid": (test) ->
    invalid = "(*#&$@(*&#$)(*&:Lkj;lkjas;dfkj HHELLO!"
    test.throws ()->
      u = trans.processors.uglify.process invalid
    test.done()

  "compile coffeescript": (test) ->
    cs = "a = 'asdf'"
    js = trans.processors.coffee.process cs
    test.equal "(function() {\n  var a;\n  a = \'asdf\';\n}).call(this);\n", js
    test.done()

  "process multiple": (test) ->
    cs = "a = 'asdf'"
    out = trans.process(['coffee', 'uglify'], cs)
    test.equal '(function(){var a;a="asdf"}).call(this)', out
    test.done()

  "process multiple with string def": (test) ->
    cs = "a = 'asdf'"
    out = trans.process('coffee, uglify', cs)
    test.equal '(function(){var a;a="asdf"}).call(this)', out
    test.done()

  "ignore unknown": (test) ->
    cs = "a = 'asdf'"
    out = trans.process(['beer'], cs)
    test.equal cs, out
    test.done()
