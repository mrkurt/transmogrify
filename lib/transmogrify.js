(function() {
  var coffee, eco, fs, paths, process, ps, qs, render, sys, uglify, url, _;
  var __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; };
  _ = require('underscore');
  uglify = require('./processors/uglify');
  coffee = require('./processors/coffee');
  url = require('url');
  eco = require('eco');
  fs = require('fs');
  sys = require('sys');
  qs = require('querystring');
  exports.processors = ps = {
    uglify: uglify,
    coffee: coffee
  };
  exports.process = process = function(processors, src) {
    var f, p, _i, _len;
    if (processors == null) {
      processors = ['coffee', 'uglify'];
    }
    if (typeof processors === 'string') {
      processors = (function() {
        var _i, _len, _ref, _results;
        _ref = processors.split(',');
        _results = [];
        for (_i = 0, _len = _ref.length; _i < _len; _i++) {
          p = _ref[_i];
          _results.push(p.trim());
        }
        return _results;
      })();
    }
    for (_i = 0, _len = processors.length; _i < _len; _i++) {
      f = processors[_i];
      if (ps[f] && ps[f].process) {
        try {
          src = ps[f].process(src);
        } catch (error) {
          error.processor = f;
          throw error;
        }
      }
    }
    return src;
  };
  exports.render = render = function(tmpl, locals) {
    var template;
    if (tmpl === '/' || tmpl === '') {
      tmpl = 'index';
    }
    template = fs.readFileSync(__dirname + ("/../templates/" + tmpl + ".html.eco"), "utf-8");
    return eco.render(template, locals);
  };
  paths = {};
  paths.GET = {
    '/compile': function(req, res) {
      return res.render('compile');
    }
  };
  paths.POST = {
    '/compile': function(req, res) {
      var out, p, post;
      post = qs.parse(req.data);
      p = req.url.query;
      out = {
        processors: p
      };
      try {
        out.output = process(p, post.data);
        res.writeHead(200, {
          'Content-Type': 'application/json'
        });
      } catch (error) {
        out.error = {
          processor: error.processor,
          message: error.message
        };
        res.writeHead(500, {
          'Content-Type': 'application/json'
        });
      }
      return res.end(JSON.stringify(out));
    }
  };
  exports.server = function(req, res) {
    res.render = __bind(function(tmpl, locals) {
      res.writeHead(200, {
        'Content-Type': 'text/html'
      });
      return res.end(render(tmpl, locals));
    }, this);
    req.data = '';
    req.addListener("data", function(chunk) {
      return req.data += chunk;
    });
    return req.addListener("end", function() {
      var m, path;
      req.url = url.parse(req.url);
      path = req.url.pathname;
      if (path.trim() === '/') {
        path = "/compile";
      }
      m = paths[req.method][path];
      if (m && m instanceof Function) {
        return m(req, res);
      } else if (m === true) {
        return res.render(path);
      } else {
        res.writeHead(404, {
          'Content-Type': 'text/plain'
        });
        return res.end("four oh four! (" + req.method + " " + req.url.pathname + ")");
      }
    });
  };
}).call(this);
