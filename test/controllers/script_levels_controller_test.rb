require 'test_helper'

class ScriptLevelsControllerTest < ActionController::TestCase
  include Devise::TestHelpers

  setup do
    @script = create(:script)
    @level = create(:level, :blockly)
    @script_level = create(:script_level, :script => @script, :level => @level)
    @user = create(:admin)
    sign_in(@user)
  end
  
  test "should show script level" do
    @controller.expects :slog

    get :show, script_id: @script.id, id: @script_level.id
    assert_response :success
  end
  
  test "should select only callouts for current script level" do
    @controller.expects :slog

    callout1 = create(:callout, script_level: @script_level)
    callout2 = create(:callout, script_level: @script_level)
    irrelevant_callout = create(:callout)
    get :show, script_id: @script.id, id: @script_level.id
    assert(assigns(:callouts_to_show).include?(callout1))
    assert(assigns(:callouts_to_show).include?(callout2))
    assert(!assigns(:callouts_to_show).include?(irrelevant_callout))
  end

  test "should localize callouts" do
    @controller.expects :slog

    create(:callout, script_level: @script_level, localization_key: 'run')
    get :show, script_id: @script.id, id: @script_level.id
    assert_not_nil(assigns(:callouts).find{|c| c['localized_text'] == 'Hit "Run" to try your program'})
  end
  
  test "should render blockly partial for blockly levels" do
    @controller.expects :slog

    script = create(:script)
    level = create(:level, :blockly)
    script_level = create(:script_level, :script => script, :level => level)
    get :show, script_id: script.id, id: script_level.id
    assert_template partial: '_blockly'
  end
  
  test "with callout defined should define callout JS" do
    @controller.expects :slog

    create(:callout, script_level: @script_level)
    get :show, script_id: @script.id, id: @script_level.id
    assert(@response.body.include?('Drag a \"move\" block and snap it below the other block'))
  end

  test "should carry over previous blocks" do
    blocks = "<hey>"
    level = Level.where(level_num: "3_8").first
    script_level = ScriptLevel.where(level_id: level.id).first
    level_source = LevelSource.lookup(level, blocks)
    Activity.create!(user: @user, level: level, lines: "1", attempt: "1", test_result: "100", time: "1000", level_source: level_source)
    next_script_level = ScriptLevel.where(level: Level.where(level_num: "3_9").first).first
    get :show, script_id: script_level.script.id, id: next_script_level.id
    assert_equal blocks, assigns["start_blocks"]
  end
end
