require 'test_helper'

class RestClientWrapperTest < ActiveSupport::TestCase
  def setup
    request_stubber([
      {
        url: /.*./,
        status: 200,
        body: {message: 'Mock response'}.to_json
      }
    ])
  end

  test '::execute_request when successful should return parsed json' do
    response = RestClientWrapper.execute_request({url: 'mock_url'})
    assert_equal({'message' => 'Mock response'}, response)
  end
end
