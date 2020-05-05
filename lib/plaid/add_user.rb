require 'json'

module Plaid
  module AddUser
    # Required parameters:
    #   api_level, username, password, type
    def add_user(api_level, username, password, type, pin = nil, options = nil)
      payload = { username: username, password: password, type: type }

      payload[:pin]     = pin if pin
      payload[:options] = options.is_a?(Hash) ? JSON.generate(options) : options if options

      res = Plaid::Connection.post(api_level, payload)
      self.user(res, api_level)
    end

    def set_user(token, api_levels=[], type=nil)
      token = token + '_' + type unless type.nil?
      self.existing_user(token, api_levels)
    end
  end
end
