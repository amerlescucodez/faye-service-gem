require File.expand_path('../lib/faye_service/version', __FILE__)

Gem::Specification.new do |s|
  s.authors                      = ["Andrei Merlescu"]
  s.email                        = ["andrei+github@merlescu.net"]
  s.description                  = s.summary = "Simple interface for Faye service messaging."
  s.homepage                     = "https://github.com/amerlescucodez/faye-service-gem"
  s.license                      = "MIT"
  s.files                        = `git ls-files | grep -Ev '^(myapp|examples)'`.split("\n")
  s.name                         = "faye_service"
  s.require_paths                = ["lib"]
  s.version                      = FayeService::VERSION
  s.add_runtime_dependency  'logging', '~> 2.2', '>= 2.2.2'
end
