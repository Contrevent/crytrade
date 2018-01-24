require 'test_helper'

class HomeControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get home_index_url
    assert_response :success
  end

  test "should get about" do
    get home_about_url
    assert_response :success
  end

  test "should get ticker" do
    get home_ticker_url
    assert_response :success
  end

  test "should get refresh" do
    get home_refresh_url
    assert_response :success
  end

end
