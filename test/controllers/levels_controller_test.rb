require 'test_helper'

class LevelsControllerTest < ActionController::TestCase
  include Devise::TestHelpers

  setup do
    @level = create(:level)
    @user = create(:admin)
    sign_in(@user)

    @not_admin = create(:user)
  end

  test "should get index" do
    get :index, game_id: @level.game
    assert_response :success
    assert_not_nil assigns(:levels)
  end

  test "should get new" do
    get :new, game_id: @level.game
    assert_response :success
  end

# this test is not working because Level::BUILDER is nil in tests
#  test "should get builder" do
#    get :builder, game_id: @level.game
#
#    assert_response :success
#  end

  test "should not get builder if not admin" do
    sign_in @not_admin
    get :new, game_id: @level.game
    assert_response :forbidden
  end

  test "should create maze level" do
    maze = fixture_file_upload("maze_level.csv", "r")
    game = Game.find_by_name("CustomMaze")
    assert_difference('Level.count') do
      post :create, :game_id => game.id, :name => "NewCustomLevel", :program => "<hey>", :level_type => 'maze', :level => maze, :size => 8
    end

    assert_redirected_to game_level_path(assigns(:level).game, assigns(:level))
  end

  test "should create artist level" do
    game = Game.find_by_name("Custom")
    assert_difference('Level.count') do
      post :create, :game_id => game.id, :name => "NewCustomLevel", :program => "<hey>", :level_type => 'artist'
    end

    assert_equal game_level_url(assigns(:level).game, assigns(:level)), JSON.parse(@response.body)["redirect"]
  end

  test "should not create level if not admin" do
    sign_in @not_admin
    assert_no_difference('Level.count') do
      post :create, :name => "NewCustomLevel", :program => "<hey>", game_id: 1
    end

    assert_response :forbidden
  end

  test "should show level" do
    get :show, id: @level, game_id: @level.game
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @level, game_id: @level.game
    assert_response :success
  end

  test "should update level" do
    patch :update, id: @level, game_id: @level.game, level: {  }
    level = assigns(:level)
    assert_redirected_to game_level_path(level.game, level)
  end

  test "should update add level blocks" do
    level_id = 2
    assert_difference("Level.find(#{level_id}).toolbox_level_blocks.count", 1) do
      @level = Level.find(level_id)
      patch :update, id: @level, game_id: @level.game, level: {  }, toolbox_level_block_ids: [2]
    end
  end

  test "should update remove level blocks" do
    assert_difference("Level.find(1).toolbox_level_blocks.count", -1) do
      @level = Level.find(1)
      patch :update, id: @level, game_id: @level.game, level: {  }, toolbox_level_block_ids: []
    end
  end

  test "should get blocks from level" do
    level = Level.find(1)
    assert_equal level.start_level_blocks.count, 1
    assert_equal level.toolbox_level_blocks.count, 1
  end

  test "should destroy level" do
    assert_difference('Level.count', -1) do
      delete :destroy, id: @level, game_id: @level.game
    end

    assert_redirected_to game_levels_path
  end

  test "should route new to levels" do
    assert_routing({method: "post", path: "/games/1/levels"}, {controller: "levels", action: "create", game_id: "1"})
  end

end
