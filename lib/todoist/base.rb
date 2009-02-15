require 'httparty'
require 'json'
module Todoist
  ##
  # The Todoist::Base class is responsible for making all queries to the
  # todoist web API.
  class Base
    include HTTParty
    format :json

    ##
    # Sets up the Todoist::Base class for making requests, setting the API key
    # and if the account is a premium one or not.
    def self.setup(token, premium = false)
      self.default_params :token => token
      @@premium = premium
      set_base_uri
    end

    private
    def self.set_base_uri
      if premium?
        base_uri 'https://todoist.com/API'
      else
        base_uri 'http://todoist.com/API'
      end
    end

    def self.premium?
      (@@premium) ? true : false
    end

    def id_array(ids)
      ids.flatten.map {|i| i.to_i }.to_json
    end

  end
end
