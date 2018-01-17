require 'test_helper'

class LedgerControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get ledger_index_url
    assert_response :success
  end

end
