Gem::Specification.new do |s|
  s.name = "transmogrify"
  s.version = "0.1.2"
  s.summary = "A ruby consumer for the transmogrify Node.js service"
  s.description = "The transmogrify gem is a thin Ruby wrapper around a Node.js based webservice that compiles CoffeeScript and uglifies Javascript. It also provides an engine for the ruby-coffee-script gem so you can use it on Heroku."

  s.files = Dir["Rakefile", "lib/**/*"]

  s.add_dependency "coffee-script", ">= 2.1.1"
  s.add_dependency "json", ">= 1.5.1"

  s.authors = ["Kurt Mackey"]
  s.email = "mrkurt@gmail.com"
  s.homepage = "http://github.com/mrkurt/transmogrify/"
end
