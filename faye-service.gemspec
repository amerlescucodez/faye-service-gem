require File.expand_path('../lib/faye_service/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors                   = ["Andrei Merlescu"]
  gem.email                     = ["andrei+github@merlescu.net"]
  gem.description               = gem.summary = "Simple interface for Faye service messaging."
  gem.homepage                  = "https://github.com/amerlescucodez/faye-service-gem"
  gem.license                   = "MIT"
  gem.files                     = `git ls-files | grep -Ev '^(myapp|examples)'`.split("\n")
  gem.name                      = "faye_service"
  gem.require_paths             = ["lib"]
  gem.version                   = FayeService::VERSION
end
