require 'net/http'
require 'faye_service/faye_service'
require 'faye_service/version'

module FayeService

  # Shortuct for current working directory
  def FayeService.path
    Dir.pwd
  end #/def

  # Shortcut to loading the configs
  def FayeService.config
    # Requires inside the rails/etc application a file called config/faye_service.yml
    if File.exists?(File.join(path, "config", "faye_service.yml"))
      config = YAML.load_file(File.join(path, "config","faye_service.yml"))
      return config
    else
      raise(StandardError,"No faye_service.yml file inside the config directory.")
    end #/if-else
  end #/def

  # Shortcut for accessing URL
  def FayeService.url
    FayeService.config["faye_service"]["url"]
  end #/def

  # Shortcut for accessing auth token
  def FayeService.auth_token
    FayeService.config["faye_service"]["auth_token"]
  end #/def

  # Shortcut for access auth service
  def FayeService.auth_service
    FayeService.config["faye_service"]["auth_service"]
  end #/def

  # Shortcut for accessing http response
  def FayeService.return_http_response?
    (FayeService.config["faye_service"]["return_response"] == "yes") ? true : false
  end #/def

  # Shortcut for publishing a new message
  def publish(channel, message)
    FayeService::Publisher.publish(channel, message)
  end #/def
  
end #/module
