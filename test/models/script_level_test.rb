require 'test_helper'

class ScriptLevelTest < ActiveSupport::TestCase
  def setup
    @script_level = create(:script_level)
    @script_level2 = create(:script_level)
    @stage = create(:stage)
    @stage2 = create(:stage)
  end

  test "setup should work" do
    assert_not_nil @script_level.script
    assert_not_nil @script_level.level
  end

  test "should get position when assigned to stage" do
    @script_level.update(stage: @stage)
    @script_level.move_to_bottom
    assert_equal 1, @script_level.position
  end
end
