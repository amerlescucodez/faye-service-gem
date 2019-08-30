# frozen_string_literal: true
require 'logging'

module FayeService
end

begin
	require 'rails'
rescue LoadError
	# do nothing
end #/begin-rescue

require 'faye_service/config'

if defined? ::Rails::Railtie
	require 'faye_service/railtie'
end #/if
