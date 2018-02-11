require 'test_helper'

class ApiOpenControllerTest < ActionDispatch::IntegrationTest
  test "should get coins" do
    get api_open_coins_url
    assert_response :success
  end

end
