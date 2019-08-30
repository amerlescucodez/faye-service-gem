module FayeService
	class << self
		def configure
			yield config
		end #/def

		def config
			@_config ||= Config.new
		end #/def
	end #/class

	class Config
		attr_accessor :url, :auth_token, :auth_service
		attr_writer :param_name

		def initialize
			@url = "http://localhost:3000"
			@auth_token = nil
			@auth_service = nil
		end #/def

		def param_name
			@param_name.respond_to?(:call) ? @param_name.call : @param_name
		end #/def
	end #/class
end #/module