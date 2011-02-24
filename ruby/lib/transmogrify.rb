require 'net/http'
require 'uri'
require 'coffee-script'
module Transmogrify
  class TransmogrifyError < ::StandardError;
    attr_accessor :inner
    attr_accessor :processor

    def initialize(msg, options = {})
      self.inner = options[:inner]
      self.processor = options[:processor]
      super(msg)
    end
  end
  class << self
    def endpoint
      @endpoint ||= nil
    end
    def endpoint=(v)
      @endpoint = v
    end

    def default_processors
      @default_processors ||= ['coffee','uglify']
    end

    def default_processors=(v)
      @default_processors = v
    end

    def post(src, options = {})
      processors = options[:processors] || default_processors
      if processors.is_a?(Array)
        processors = processors.join(',')
      end

      e = options[:endpoint] || endpoint

      res = Net::HTTP.post_form(URI.parse(e + '?' + processors), {'data' => src})
      begin
        output = JSON.parse(res.body)
      rescue
        raise TransmogrifyError.new "Could not decode Transmogrify response", :inner => $!
      end
      if res.code.to_s == '200'
        output
      else
        raise TransmogrifyError.new output['message'], :processor => output['processor']
      end
    end

    def uglify(script)
      post(script, :processors => 'uglify')[:output]
    end

    def install_coffeescript!
      CoffeeScript.engine = CoffeeScript::Engines::Transmogrify
    end
  end
end
module CoffeeScript
  module Engines
    module Transmogrify
      class << self
        def compile(script, options = {})
          begin
            ::Transmogrify.post(script)['output']
          rescue ::Transmogrify::TransmogrifyError => ex
            if ex.inner
              raise EngineError, ex.message
            else
              raise CompilationError, ex.message
            end
          end
        end
      end
    end
    CoffeeScript.engine ||= Transmogrify
  end
end
