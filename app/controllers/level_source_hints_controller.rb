class LevelSourceHintsController < ApplicationController
  before_filter :authenticate_user!

  def add_hint
    raise "unauthorized" if !current_user.admin?
    @level_source_id = params[:level_source_id]
    common(@level_source_id)
  end

  def show_hints
    raise "unauthorized" if !current_user.admin?

    @level_source_id = params[:level_source_id]
    @hints = LevelSourceHint.where(level_source_id: @level_source_id).sort_by { |hint| -hint.times_proposed}
    common(@level_source_id)
  end

  def add_pop_hint
    raise "unauthorized" if !current_user.admin?
    unsuccessful_level_sources = FrequentUnsuccessfulLevelSource.where(active: true).order('num_of_attempts desc')
    if (params[:idx].to_i >= 0 && unsuccessful_level_sources.length > params[:idx].to_i)
      @level_source_id = unsuccessful_level_sources.at(params[:idx].to_i).level_source_id
      @num_of_attempts = unsuccessful_level_sources.at(params[:idx].to_i).num_of_attempts
      @prev_path = add_pop_hint_path(params[:idx].to_i - 1)
      @current_path = add_pop_hint_path(params[:idx].to_i)
      @next_path = add_pop_hint_path(params[:idx].to_i + 1)
      common(@level_source_id)
    elsif (params[:idx].to_i < 0)
      redirect_to frequent_unsuccessful_level_sources_path, notice: 'You have reached the first error program.'
    else
      redirect_to frequent_unsuccessful_level_sources_path, notice: 'No more hint to be added. Thank you very much!'
    end
  end

  def add_pop_hint_per_level
    raise "unauthorized" if !current_user.admin?
    unsuccessful_level_sources = FrequentUnsuccessfulLevelSource.where(active: true, level_id: params[:level_id].to_i).order('num_of_attempts desc')
    if (params[:idx].to_i >= 0 && unsuccessful_level_sources.length > params[:idx].to_i)
      @level_source_id = unsuccessful_level_sources.at(params[:idx].to_i).level_source_id
      @num_of_attempts = unsuccessful_level_sources.at(params[:idx].to_i).num_of_attempts
      @prev_path = add_pop_hint_per_level_path(params[:level_id].to_i, params[:idx].to_i - 1)
      @current_path = add_pop_hint_per_level_path(params[:level_id].to_i, params[:idx].to_i)
      @next_path = add_pop_hint_per_level_path(params[:level_id].to_i, params[:idx].to_i + 1)
      common(@level_source_id)
      render 'add_pop_hint'
    elsif (params[:idx].to_i < 0)
      redirect_to frequent_unsuccessful_level_sources_path, notice: 'You have reached the first error program of this level.'
    else
      redirect_to frequent_unsuccessful_level_sources_path, notice: 'No more hint to be added. Please select another level.'
    end
  end

  def create
    # Find or create the hint data
    level_source_hint =
        LevelSourceHint.where(level_source_id: params[:level_source_id], hint:  params[:hint_content]).first_or_create
    # Update the times this hint has been proposed
    level_source_hint.times_proposed = (level_source_hint.times_proposed || 0) + 1
    level_source_hint.save!

    # Set the associated frequent_unsuccessful_level_source to be inactive
    FrequentUnsuccessfulLevelSource.where(level_source_id: params[:level_source_id]).each do | unsuccessful_level_source |
      unsuccessful_level_source.active = false
      unsuccessful_level_source.save!
    end

    # Redirecting to the params[:redirect] page
    redirect_url = params[:redirect]
    redirect_to redirect_url, notice: I18n.t('add_hint_form.submit')
  end

  protected
  def common(level_source_id)
    @level_source = LevelSource.find(level_source_id)
    @start_blocks = @level_source.data
    @level = @level_source.level
    @game = @level.game
    @full_width = true
    @hide_source = false
    @share = true
  end
end
