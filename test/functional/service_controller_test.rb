require 'test_helper'

class ServiceControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
  end

  test "should get welcome" do
    get :welcome
    assert_response :success
  end

end
