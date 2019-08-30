require 'net/http'
require 'json'
module FayeService
	class Publisher
		class << self
			# Creates a new HTTP Request with the channel and message to broadcast to any potential channel subscribers
			#
			# channel => String
			# => Channel must be structured like: 
			#    /channel/name
			#    /parent/child
			#    /parent/child1/child2
			#    /parent/child1/child2/child3
			#    /parent/child1/child2/child3/child4
			#    /parent/child1/child2/child3/child4/child5
			#    /parent/child1/child2/child3/child4/child5/child6
			#    identifier-identifier-identifier
			#    identifier-identifier-identifier-identifier
			#    identifier-identifier-identifier-identifier-identifier
			#    identifier-identifier-identifier-identifier-identifier-identifier
			#    identifier-identifier-identifier-identifier-identifier-identifier-identifier
			# => Channels can only go 6 children deep
			# => Channels must be between 3 and 32 characters in length
			# => Channels can only contain abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUBWXYV0123456789-
			#
			# message => String, Array, or Hash
			# => Will be parsed into JSON
			# => Should be less than 10KB in size (no programmed limit)
			
			def publish(channel, message)
				FayeService.logger.debug "Attempting to send #{message.length} bytes to #{channel}."
				if channel =~ %r{^(/[\w-]{3,32}\/[\w-]{3,32}?(\/[\w-]{3,32})?(\/[\w-]{3,32})?(\/[\w-]{3,32})?(\/[\w-]{3,32})?(\/[\w-]{3,32})?)$} || channel =~ %r{^([\w-]{3,32}[\w-]{3,32}?([\w-]{3,32})?([\w-]{3,32})?([\w-]{3,32})?([\w-]{3,32})?([\w-]{3,32})?)$}
					payload = {
						:channel => channel,
						:data => message,
						:ext => {
							:auth_token => FayeService.config.auth_token,
							:auth_service => FayeService.config.auth_service
						}
					}
					headers = {
						"Origin": FayeService.config.origin
					}
					uri = URI.parse(FayeService.config.url)
					response = nil
					Net::HTTP.start(uri.host, uri.port, use_ssl: FayeService.config.use_ssl) do |http|
						req = Net::HTTP::Post.new(uri)
						req['Content-Type'] = 'application/json'
						req['Referrer'] = FayeService.config.origin
						req.body = payload.to_json
						response = http.request(req)
					end #/block
					return {
						success: true,
						uri: uri.to_json,
						channel: channel,
						data: message,
						info: "Sending message to #{channel} via #{uri}.",
						response: response
					}
				else
					return {
						success: false,
						channel: channel,
						data: message,
						error: "Invalid channel name provided: #{channel}"
					}
				end #/if
			end #/def
		end #/class
	end
end