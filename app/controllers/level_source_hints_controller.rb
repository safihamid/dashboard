class LevelSourceHintsController < ApplicationController
  before_filter :authenticate_user!

  def add_hint
    raise "unauthorized" if !current_user.admin?
    common
  end

  def show_hints
    raise "unauthorized" if !current_user.admin?

    @hints = LevelSourceHint.where( "level_source_id = ?", params[:level_source_id]).sort_by { |hint| -hint.times_proposed}
    common
  end

  def create
    # Find or create the hint data
    level_source_hint =
        LevelSourceHint.where(level_source_id: params[:level_source_id], hint:  params[:hint_content]).first_or_create
    # Update the times this hint has been proposed
    level_source_hint.times_proposed = (level_source_hint.times_proposed || 0) + 1
    level_source_hint.save!

    # Redirecting to the level stats page
    redirect_url = params[:redirect]
    redirect_to redirect_url, notice: I18n.t('add_hint_form.submit')
  end

  protected
  def common
    @level_source = LevelSource.find(params[:level_source_id])
    @start_blocks = @level_source.data
    @level = @level_source.level
    @game = @level.game
    @full_width = true
    @hide_source = false
    @share = true
  end
end
