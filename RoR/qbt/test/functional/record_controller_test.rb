require 'test_helper'

class RecordControllerTest < ActionController::TestCase
  test "should get taskInfo" do
    get :taskInfo
    assert_response :success
  end

  test "should get userInfo" do
    get :userInfo
    assert_response :success
  end

  test "should get songInfo" do
    get :songInfo
    assert_response :success
  end

end
