module Omdb
    class RequestCreatorTest < ActiveSupport::TestCase
      def setup
        request_stubber([
          {
            url: /.omdb./,
            status: 200,
            body: json_response('omdb_response')
          }
        ])
      end
  
      test 'on initialize add apikey to params' do
        request_maker = Omdb::RequestCreator.new({})
  
        assert_not request_maker.params.empty?
        assert request_maker.params.key?(:apikey)
        assert_equal ENV['OMDB_API_KEY'], request_maker.params[:apikey]
      end
  
      test '#perform_request should make request to omdb api passsing params' do
        request_maker = Omdb::RequestCreator.new({t: 'tt1130884'})
  
        response = request_maker.perform_request
        assert_equal 'Shutter Island', response[:Title]
        assert_equal 'Mystery, Thriller', response[:Genre]
        assert_equal 'Martin Scorsese', response[:Director]
      end
    end
  end
  