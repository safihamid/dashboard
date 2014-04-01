require "csv"

class LevelsController < ApplicationController
  include LevelsHelper
  include ActiveSupport::Inflector
  before_filter :authenticate_user!
  skip_before_filter :verify_params_before_cancan_loads_model, :only => [:create]
  load_and_authorize_resource :except => [:create]
  check_authorization

  before_action :set_level, only: [:show, :edit, :update, :destroy]

  # GET /levels
  # GET /levels.json
  def index
    @game = Game.find(params[:game_id])
    @levels = @game.levels
  end

  # GET /levels/1
  # GET /levels/1.json
  def show
    set_videos_and_blocks_and_callouts

    @fallback_response = {
      success: {message: 'good job'},
      failure: {message: 'try again'}
    }

    @full_width = true
  end

  # GET /levels/1/edit
  def edit
    level = Level.find(params[:id])
    @blocks = Block.all
    @start_blocks = level.start_level_blocks.collect(&:block)
    @toolbox_blocks = level.toolbox_level_blocks.collect(&:block)
  end

  # POST /levels
  # POST /levels.json
  def create
    authorize! :create, :level
    case params[:level_type]
    when 'maze'
      create_maze
    when 'artist'
      create_artist
    else
      raise "Unkown level type #{params[:level_type]}"
    end
  end

  def create_maze
    contents = CSV.new(params[:maze_source].read)
    maze = contents.read[0...params[:size].to_i].to_s
    game = Game.custom_maze
    @level = Level.create(level_params.merge(maze: maze, game: game, user: current_user, level_num: 'custom', skin: 'birds'))
    redirect_to game_level_url(game, @level)
  end

  def create_artist
    game = Game.find(params[:game_id])
    @level = Level.create(instructions: params[:instructions], name: params[:name], x: params[:x], y: params[:y], game: game, user: current_user, level_num: 'custom', skin: 'artist')
    solution = LevelSource.lookup(@level, params[:program])
    @level.update(solution_level_source: solution)
    render json: { redirect: game_level_url(game, @level) }
  end

  # PATCH/PUT /levels/1
  def update
    if @level.update(level_params)
      update_blocks ToolboxLevelBlock, StartLevelBlock
      redirect_to [@level.game, @level], notice: I18n.t('crud.updated', Level.model_name.human)
    else
      edit
      render 'edit'
    end
  end

  def update_blocks(*block_models)
    block_models.each do |block_model|
      old_blocks = block_model.where(level: @level)
      block_attribute = underscore(block_model)  # ToolboxLevelBlock => toolbox_level_block
      params[block_attribute + '_ids'] ||= []

      level_blocks = params[block_attribute + '_ids'].collect do |block_id|
        block_model.where(level: @level, block_id: block_id).first_or_create
      end
      block_model.delete(old_blocks - level_blocks)
    end
  end

  # DELETE /levels/1
  # DELETE /levels/1.json
  def destroy
    @level.destroy
    redirect_to(params[:redirect] || game_levels_url)
  end

  def new
    authorize! :create, :level
    case params[:type]
    when 'artist'
      artist_builder
    when 'maze'
      @game = Game.custom_maze
      @level = Level.new
      render :maze_builder
    end
    @levels = Level.where(user: current_user)
  end

  def artist_builder
    authorize! :create, :level
    @level = Level::BUILDER
    @game = @level.game
    @full_width = true
    @artist_builder = true
    @callback = game_levels_path @game
    @level.x = params[:x]
    @level.y = params[:y]
    @level.start_direction = params[:start_direction]
    show
    render :show
  end


  private
    # Use callbacks to share common setup or constraints between actions.
    def set_level
      @level = Level.find(params[:id])
      @game = @level.game || Game.find(params[:game_id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def level_params
      params[:level].permit([:name, :level_url, :level_num, :skin, :instructions, :x, :y, :start_direction, {concept_ids: []}])
    end
end
