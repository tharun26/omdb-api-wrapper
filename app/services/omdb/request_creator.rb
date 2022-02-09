module Omdb
    class RequestCreator
      BASE_URL = 'https://www.omdbapi.com/'
      attr_accessor :params
  
      def initialize(params = {})
        @params = params
        add_api_key
      end
  
      def perform_request
        options = {
          headers: {
            params: params,
          },
          url: BASE_URL,
        }
        RestClientWrapper.execute_request(options)
      end
  
      private
        def add_api_key
          params.merge!(apikey: ENV['OMDB_API_KEY'])
        end
    end
  end
  