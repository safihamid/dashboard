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

  test "placeholder" do
    assert true
  end
end
