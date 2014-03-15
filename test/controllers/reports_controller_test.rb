require 'test_helper'

class ReportsControllerTest < ActionController::TestCase
  include Devise::TestHelpers

  setup do
    @admin = create(:admin)
    sign_in(@admin)

    @not_admin = create(:user)
  end

  test "should get user_stats" do
    get :user_stats, :user_id => @not_admin.id
    assert_response :success
  end

  test "should not get user_stats if not signed in" do
    sign_out @admin
    get :user_stats, :user_id => @not_admin.id

    assert_redirected_to_sign_in
  end

  test "should get user_stats for yourself if not admin" do
    sign_in @not_admin

    get :user_stats, :user_id => @not_admin.id

    assert_response :success
  end

  test "should not get user_stats for other users if not admin" do
    sign_in create(:user)

    get :user_stats, :user_id => @not_admin.id

    assert_response :forbidden
  end


  test "should get header_stats" do
    get :header_stats
    assert_response :success
  end

  test "should get header_stats if not signed in" do
    sign_out @admin
    get :header_stats
    assert_response :success
  end

  test "should get prizes" do
    get :prizes
    assert_response :success
  end

  test "should get prizes if not admin" do
    sign_in @not_admin
    get :prizes
    assert_response :success
  end

  test "should not get prizes if not signed in" do
    sign_out @admin
    get :prizes

    assert_redirected_to_sign_in
  end

  test "should get usage" do
    get :usage, :user_id => @not_admin.id
    assert_response :success
  end

  test "should not get usage if not signed in" do
    sign_out @admin
    get :usage, :user_id => @not_admin.id

    assert_redirected_to_sign_in
  end

  test "should get usage for yourself if not admin" do
    sign_in @not_admin

    get :usage, :user_id => @not_admin.id

    assert_response :success
  end

  test "should get usage for other users if not admin" do
    # hm. really?
    sign_in create(:user)

    get :usage, :user_id => @not_admin.id

    assert_response :success
  end

  generate_admin_only_tests_for :all_usage

  generate_admin_only_tests_for :admin_stats

  test "should get students" do
    get :students
    assert_response :success
  end

  test "should get students if not admin" do
    sign_in @not_admin
    get :students
    assert_response :success
  end

  test "should not get students if not signed in" do
    sign_out @admin
    get :students

    assert_redirected_to_sign_in
  end


  test "should get level_stats" do
    get :level_stats, {:level_id => create(:level).id}
    assert_response :success
  end

  test "should not get level_stats if not admin" do
    sign_in @not_admin
    get :level_stats, {:level_id => create(:level).id}
    assert_response :forbidden
  end

  test "should not get level_stats if not signed in" do
    sign_out @admin
    get :level_stats, {:level_id => create(:level).id}

    assert_redirected_to_sign_in
  end
  
end
