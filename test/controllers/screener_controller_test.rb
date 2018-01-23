require 'test_helper'

class ScreenerControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get screener_controller_index_url
    assert_response :success
  end

  test "should get new" do
    get screener_controller_new_url
    assert_response :success
  end

  test "should get save" do
    get screener_controller_save_url
    assert_response :success
  end

  test "should get destroy" do
    get screener_controller_destroy_url
    assert_response :success
  end

  test "should get run" do
    get screener_controller_run_url
    assert_response :success
  end

end
