require 'test_helper'

class ActivitiesControllerTest < ActionController::TestCase
  include Devise::TestHelpers
  setup do
    @user = create(:user)
    sign_in(@user)

    @activity = create(:activity, user: @user)

    @admin = create(:admin)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:activities)
  end

  test "should get index with edmodo header" do
    @request.headers["Accept"] = "image/*"
    @request.headers["User-Agent"] = "Edmodo/14 CFNetwork/672.0.2 Darwin/14.0.0"
    get :index
    assert_response :success
    assert_not_nil assigns(:activities)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create activity" do
    assert_difference('Activity.count') do
      post :create, activity: {  }
    end

    assert_redirected_to activity_path(assigns(:activity))
  end

  test "should create activity with milestone" do
    script_level = ScriptLevel.find(2)
    script_level_next = ScriptLevel.find(3)

    @controller.expects :log_milestone
    @controller.expects :slog

    assert_difference('Activity.count') do
      post :milestone, user_id: @user, script_level_id: script_level, :lines => "1", :attempt => "1", :result => "true", :testResult => "100", :time => "1000", :app => "test", :program => "<hey>"
    end
    
    assert_response :success
    parsed_response = JSON.parse @response.body
    assert_equal parsed_response["redirect"], script_level_path(script_level_next.script, script_level_next)
  end

  test "should log with anonymous milestone" do
    sign_out @user
    
    script_level = ScriptLevel.find(2)
    script_level_next = ScriptLevel.find(3)

    @controller.expects :log_milestone
    @controller.expects :slog
    
    post :milestone, user_id: 0, script_level_id: script_level.id.to_s, :lines => "1", :attempt => "1", :result => "true", :testResult => "100", :time => "1000", :app => "test", :program => "<hey>"
    
    assert_response :success
    parsed_response = JSON.parse @response.body
    assert_equal parsed_response["redirect"], script_level_path(script_level_next.script, script_level_next)
  end

  test "should show activity" do
    get :show, id: @activity
    assert_response :success
  end

  test "admin should get edit" do
    sign_in @admin

    get :edit, id: @activity
    assert_response :success
  end

  test "admin should update activity" do
    sign_in @admin
    patch :update, id: @activity, activity: {  }
    assert_redirected_to activity_path(assigns(:activity))
  end

  test "user can save an activity to their gallery" do
    sign_in @user
    patch :update, id: @activity, activity: { :saved_to_gallery => true }
    assert_redirected_to activity_path(assigns(:activity))

    assert @activity.reload.saved_to_gallery?
  end

  test "user cannot update another user's activity" do
    another_user = create(:user)
    sign_in another_user
    assert another_user != @activity.user
    patch :update, id: @activity, activity: { :saved_to_gallery => true }

    assert_response 403

    assert !@activity.reload.saved_to_gallery?
  end

  test "admin should destroy activity" do
    sign_in @admin
    assert_difference('Activity.count', -1) do
      delete :destroy, id: @activity
    end

    assert_redirected_to activities_path
  end

  test "user cannot destroy activity" do
    sign_in @user
    assert_no_difference('Activity.count') do
      delete :destroy, id: @activity
    end

    assert_response 403
  end

end
