class RestClientWrapper
    class << self
      def execute_request(params = {})
        params[:method] ||= :get
        params[:headers] ||= {}
        params[:timeout] ||= 60
  
        parse(RestClient::Request.execute(params)).with_indifferent_access
      end
  
      private
        def parse(response)
          JSON.parse(response)
        end
    end
  end
  