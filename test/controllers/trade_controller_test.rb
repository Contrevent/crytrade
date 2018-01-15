require 'test_helper'

class TradeControllerTest < ActionDispatch::IntegrationTest
  test "should get list" do
    get trade_list_url
    assert_response :success
  end

  test "should get create" do
    get trade_create_url
    assert_response :success
  end

  test "should get update" do
    get trade_update_url
    assert_response :success
  end

  test "should get close" do
    get trade_close_url
    assert_response :success
  end

end
