
module Todoist
  ##
  # It is the connection module's responsibility to make all requests to the
  # todoist API, and to deserialize the response into a Hash.  Before any
  # requests are made to the todoist service, the connection information should
  # be provided via the setup method.
  module Connection

    @@url_base = 'todoist.com'
    @@api_base = '/API'
    @@is_set_up = false

    ##
    #
    # This method should be called before all others to initialize the
    # variables needed for any API requests, the API key and if the account is
    # premium or not.  No actual request is made at this stage.
    #
    # @param [String] api_key   The todoist API key, findable in your preferences
    # @param [Boolean] premium  Is the account premium? If set to true, API
    #                           requests are made via https.  Not required and
    #                           defaults to false.
    #
    def self.setup(api_key, premium = false)
      @@is_set_up = true
      @@api_key = api_key
      @@premium = premium
    end

    ##
    #
    # Instantiates and makes a query to the given API method with the provided
    # request keys.
    #
    # The response is parsed from the JSON to native ruby objects as appropriate
    #
    # @param [String] api_method    The API method to call.  Must be supplied.
    # @param [Hash] keys            An array of keys to be included in the URL.
    #                               This shouldn't include the token
    #
    # @return [Hash] The response, parsed from the JSON
    #
    # @raise [NotSetupError] The connection has not been set up
    # @raise [TokenNotCorrect] The server returned a message indicating a bad
    #                        token was sent
    # @raise [InvalidAPICall] The request was made to an invalid API address
    # @raise [BadResponse]   The server didn't return a 200 (and wasn't a bad
    #                        token or a 404)
    #
    def self.api_request(api_method, keys={})
      raise(NotSetupError, "Call Todoist::Connection.setup before making any API requests") unless @@is_set_up

      # first, construct our URL string
      request = construct_request_string(api_method, keys)

      # next, make our request
      response = make_api_request(request)

      return JSON.parse(reponse)
    end

    protected

    # constructs a request string from the method and the keys passed in, adding
    # the token
    def self.construct_request_string(api_method, keys={})
      # convert our hash of keys into an appropriate array.
      urlized_keys = jsonized_url_array(keys)
      urlized_keys.unshift "token=#{@@api_key}"

      return "#{@@api_base}/#{api_method}?#{urlized_keys.join('&')}"
    end

    # converts the keys to a JSONized array, and CGI escapes them
    def self.jsonized_url_array(keys={})
      array = keys.inject([]) do |array, h|
        jsonized = h[1].to_json
        escaped = CGI.escape(jsonized)
        array << "#{h[0]}=#{escaped}"
      end
      return array
    end

    # makes a request from the todoist API
    def self.make_api_request(request)
      port = (@@premium) ? 443 : 80
      http = Net::HTTP.new(@@url_base, port)
      http.use_ssl = @@premium

      new_request = Net::HTTP::Get.new(request)

      # actually make our request!
      response = http.request(new_request)

      if response.code == '200'
        return JSON.parse(response.body)
      else
        if response.code == '404'
          raise InvalidAPICall
        elsif response.code == '500' && response.body =~ /Token not correct!/
          raise TokenNotCorrect
        else
          raise(BadResponse,"#{response.code} - #{response.body})")
        end
      end
    end
  end
end
