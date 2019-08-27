require 'net/http'
require 'faye_service/publisher'
require 'faye_service/version'
require 'logging'

module FayeService

  @config = {url: nil, auth_token: nil, auth_service: nil}


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
  def FayeService.config
    return @config
  end #/def

  def FayeService.set_config(new_config)
    @config = new_config
  end #/def

  def FayeService.set_url(url)
    @config[:url] = url
  end #/def

  def FayeService.set_auth_token(auth_token)
    @config[:auth_token] = auth_token
  end #/def

  def FayeService.set_auth_service(auth_service)
    @config[:auth_service] = auth_service
  end #/def

  def FayeService.url
    FayeService.config[:url]
  end #/def

  def FayeService.auth_token
    FayeService.config[:auth_token]
  end #/def

  def FayeService.auth_service
    FayeService.config[:auth_service]
  end #/def

  # alias of FayeService::Publisher.publish inside lib/faye_service/publisher.rb
  def FayeService.publish(channel, message)
    raise(StandardError,"Undefined config.url") if FayeService.url.nil?
    raise(StandardError,"Undefined config.auth_token") if FayeService.auth_token.nil?
    raise(StandardError,"Undefined config.auth_service") if FayeService.auth_service.nil?
    FayeService::Publisher.publish(channel, message)
  end #/def

end #/module
