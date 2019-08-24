module FayeService
	module Publisher
		class << self
			def publish(channel,message)
				if channel =~ %r{^(/[\w-]{3,32}\/[\w-]{3,32}?(\/[\w-]{3,32})?(\/[\w-]{3,32})?(\/[\w-]{3,32})?(\/[\w-]{3,32})?(\/[\w-]{3,32})?)$}
					message = {
						:channel => channel,
						:data => message,
						:ext => {
							:auth_token => FayeService::auth_token,
							:auth_service => FayeService::auth_service
						}
					}
					uri = URI.parse(FayeService::url)
					http_result = Net::HTTP.post_form(uri, :message => message.to_json)
					
					# Was the POST successful?
					if FayeService.return_http_response?
						if [Net::HTTPSuccess, Net::HTTPRedirection].include?(http_result)
							return http_result.body
						else
							return "Bad Request%"
						end #/if-else
					else
						return true
					end #/if-else
				end #/if
			end #/def
		end #/class
	end #/module
end #/module

