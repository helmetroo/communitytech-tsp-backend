require 'test_helper'

class ShortestRouteControllerTest < ActionDispatch::IntegrationTest
  test "should get get" do
    get shortest_route_get_url
    assert_response :success
  end

end
