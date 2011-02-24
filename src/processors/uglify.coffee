uglify = require('uglify-js')
_ = require('underscore')

parser = uglify.parser
js = uglify.uglify

exports.process = _.compose(js.gen_code, js.ast_squeeze, js.ast_mangle, parser.parse)
