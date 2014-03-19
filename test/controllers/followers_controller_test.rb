require 'test_helper'

class FollowersControllerTest < ActionController::TestCase
  include Devise::TestHelpers

  setup do
    @laurel = create(:teacher)
    @laurel_section_1 = create(:section, :user => @laurel)
    @laurel_section_2 = create(:section, :user => @laurel)
    
    @chris = create(:teacher)
    @chris_section = create(:section, :user => @chris)

    @student = create(:user)

    sign_in @laurel
  end

  test "remove from section" do
    Follower.create!(user: @laurel, student_user: @student, section: @laurel_section_1)

    assert_difference('@laurel_section_1.reload.followers.count', -1) do
      post :remove_from_section, :section_id => @laurel_section_1.id, :follower_id => @student.id
    end

    assert_redirected_to manage_followers_path
  end


  test "remove from section pretends to succeed when user has already been removed" do
    assert_no_difference('@laurel_section_1.reload.followers.count', -1) do # not actually removing anything
      post :remove_from_section, :section_id => @laurel_section_1.id, :follower_id => @student.id
    end

    assert_redirected_to manage_followers_path
  end

end
