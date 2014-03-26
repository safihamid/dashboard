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
    assert(assigns(:callouts).include?(callout1))
    assert(assigns(:callouts).include?(callout2))
    assert(!assigns(:callouts).include?(irrelevant_callout))
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

    callout = create(:callout, script_level: @script_level)
    get :show, script_id: @script.id, id: @script_level.id
    assert(@response.body.include?(callout.text))
  end

  test "should have global event bus" do
    @controller.expects :slog

    create(:callout, script_level: @script_level)
    get :show, script_id: @script.id, id: @script_level.id
    assert(@response.body.include?('cdo.eventType.MODAL_HIDDEN'))
  end
end
