require 'test_helper'

class HistoryControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get history_index_url
    assert_response :success
  end

  test "should get update" do
    get history_update_url
    assert_response :success
  end

end
