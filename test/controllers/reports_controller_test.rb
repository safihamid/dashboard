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

  generate_admin_only_tests_for :assume_identity_form

  test "should assume_identity" do
    post :assume_identity, {:user_id => @not_admin.id}
    assert_redirected_to '/'

    assert_equal @not_admin.id, session['warden.user.user.key'].first.first
  end

  test "should assume_identity by username" do
    post :assume_identity, {:user_id => @not_admin.username}
    assert_redirected_to '/'

    assert_equal @not_admin.id, session['warden.user.user.key'].first.first
  end

  test "should assume_identity by email" do
    post :assume_identity, {:user_id => @not_admin.email}
    assert_redirected_to '/'

    assert_equal @not_admin.id, session['warden.user.user.key'].first.first
  end

  test "should assume_identity error if not found" do
    post :assume_identity, {:user_id => 'asdkhaskdj'}
    
    assert_response :success

    assert flash[:error]
  end

  test "should not assume_identity if not admin" do
    sign_in @not_admin
    post :assume_identity, {:user_id => @admin.id}
    assert_response :forbidden
    assert_equal @not_admin.id, session['warden.user.user.key'].first.first # no change
  end

  test "should not assume_identity if not signed in" do
    sign_out @admin
    post :assume_identity, {:user_id => @admin.id}

    assert_redirected_to_sign_in
  end


end
