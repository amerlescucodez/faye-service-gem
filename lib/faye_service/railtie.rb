# frozen_string_literal: true

module FayeService
  class Railtie < ::Rails::Railtie #:nodoc:
    # Doesn't actually do anything. Just keeping this hook point, mainly for compatibility
    initializer 'faye_service' do
    end
  end
end