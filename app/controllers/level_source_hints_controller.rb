class LevelSourceHintsController < ApplicationController

  def add_hint
    @level_source = LevelSource.find(params[:level_source_id])
    @start_blocks = @level_source.data
    @level = @level_source.level
    @game = @level.game
    @full_width = true
    @hide_source = false
    @share = true

    render 'level_source_hints/new'
  end

  def index
  end

  def create
    # Find or create the hint data
    level_source_hint =
        LevelSourceHint.where("level_source_id = ? AND hint = ?", params[:level_source_id], params[:hint_content])
        .first_or_create(:level_source_id => params[:level_source_id], :hint => params[:hint_content])
    # Update the times this hint has been proposed
    level_source_hint.times_proposed = level_source_hint.times_proposed.nil? ? 1 : level_source_hint.times_proposed + 1
    level_source_hint.save!

    # Redirecting to the level stats page
    redirect_url = params[:redirect]
    redirect_to redirect_url, notice: I18n.t('add_hint_form.submit')
  end
end
