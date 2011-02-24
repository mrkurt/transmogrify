require "test/unit"
require "transmogrify"
require 'fakeweb'

class Transmogrify::TestCase < Test::Unit::TestCase
  undef_method :default_test if method_defined? :default_test

  def self.test(name, &block)
    define_method("test #{name.inspect}", &block)
  end
end

Transmogrify.endpoint = "http://transmogrify.local/compile"
FakeWeb.allow_net_connect = false

def register_compile(options)
  FakeWeb.register_uri(:post, "http://transmogrify.local/compile", options)
end
