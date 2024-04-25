require "test_helper"

class CoversControllerTest < ActionDispatch::IntegrationTest
  test "should get show" do
    get covers_show_url
    assert_response :success
  end
end
