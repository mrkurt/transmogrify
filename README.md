Transmogrify!!!
===============

Transmogrify is a Node.js service that compiles CoffeeScript and compresses Javascript (or both at once). This is intended to be used in environments where you can't install CoffeeScript or a decent javascript minifier for some reason (like Heroku!)

To test:

    cake test

To run server:

    cake server --port <NUMBER>
    http://localhost:3010

Ruby Wrapper and ruby-coffee-script integration
===============================================

`gem install transmogrify` will get you ruby-coffee-script integration. It will post to `http://transmogrify.credibl.es:8080` by default, if you want to point to your own node.js endpoint running transmogrify, specify it like so (this can go in a Rails initializer):

    Transmogrify.endpoint = "http://path.to/compile"
