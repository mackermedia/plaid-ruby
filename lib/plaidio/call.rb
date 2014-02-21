module Plaidio
  require 'rest-client'
  class Call

    BASE_URL = 'https://tartan.plaid.com/'
    
    # This initializes our instance variables, and sets up a new Customer class. 
    def initialize
      Plaidio::Configure::KEYS.each do |key|
        instance_variable_set(:"@#{key}", Plaidio.instance_variable_get(:"@#{key}"))
      end
    end

    def add_account(type,username,password,email)
      post('/connect',type,username,password,email)
      return parse_response(@response)
    end
    
    protected

    def parse_response(response)
      case response.code 
      when "200"
        @parsed_response = Hash.new
        @parsed_response[:code] = response.code
        response = JSON.parse(response)
        @parsed_response[:access_token] = response["access_token"]
        @parsed_response[:accounts] = response["accounts"]
        @parsed_response[:transactions] = response["transactions"]
        return @parsed_response
      when "201"
        @parsed_response = Hash.new
        @parsed_response[:code] = response.code
        response = JSON.parse(response)
        @parsed_response = Hash.new
        @parsed_response[:type] = response["type"]
        @parsed_response[:access_token] = response["access_token"]
        @parsed_response[:mfa_info] = response["mfa_info"]
        return @parsed_response
      else 
        @parsed_response = Hash.new
        @parsed_response[:code] = response.code
        @parsed_response[:message] = response
        return @parsed_response
      end
    end

    private

    def post(path,type,username,password,email)
      url = BASE_URL + path
      @response = RestClient.post url, :client_id => self.instance_variable_get(:'@customer_id') ,:secret => self.instance_variable_get(:'@secret'), :type => type ,:credentials => {:username => username, :password => password} ,:email => email
      return @response
    end
    
  end
end