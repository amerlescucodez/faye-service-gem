require 'net/http'
require 'faye_service/publisher'
require 'faye_service/version'
require 'logging'

module FayeService

  @logger = nil

  # Shortcut to the logger variable
  def FayeService.logger
    @logger
  end #/def

  # Shortuct for current working directory
  def FayeService.path
    Dir.pwd
  end #/def

  # Loads the config/faye_service.yml file and returns its YAML instance
  #
  # config/faye_service.yml
  # =======================
  # faye_service: 
  #   url: http://0.0.0.0:8080/faye
  #   auth_token: APPLICATION_TOKEN
  #   auth_service: SERVICE_NAME
  #   return_response: no
  def FayeService.config
    # Requires inside the rails/etc application a file called config/faye_service.yml
    if File.exists?(File.join(path, "config", "faye_service.yml"))
      config = YAML.load_file(File.join(path, "config","faye_service.yml"))
      return config
    else
      raise(StandardError,"No faye_service.yml file inside the config directory.")
    end #/if-else

    @logger = Logging.logger['FayeService']
    @logger.level = :"#{config["faye_service"]["log_level"]||"warn"}"
  end #/def

  # Reads the YAML config file and extracts the faye_service->url definition
  # => If undefined, raise a Ruby standard error since this gem depends on its definition
  def FayeService.url
    FayeService.config["faye_service"]["url"]
  end #/def

  # Reads the YAML config file and extracts the faye_service->auth_token definition
  # => If undefined, return empty string
  def FayeService.auth_token
    FayeService.config["faye_service"]["auth_token"]
  end #/def

  # Reads the YAML config file and extracts the faye_service->auth_service definition
  # => If undefined, return empty string
  def FayeService.auth_service
    FayeService.config["faye_service"]["auth_service"]
  end #/def

  # alias of FayeService::Publisher.publish inside lib/faye_service/publisher.rb
  def FayeService.publish(channel, message)
    FayeService::Publisher.publish(channel, message)
  end #/def

end #/module
