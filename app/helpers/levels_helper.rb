module LevelsHelper
  def build_script_level_path(script_level)
    if Script::HOC_ID == script_level.script_id
      hoc_chapter_path(script_level.chapter)
    else
      script_level_path(script_level.script, script_level)
    end
  end

  def build_script_level_url(script_level)
    url_from_path(build_script_level_path(script_level))
  end

  def url_from_path(path)
    "#{root_url.chomp('/')}#{path}"
  end

  def set_videos_and_blocks_and_callouts
    solution = @level.solution_level_source
    @solution_blocks = solution.data if solution

    @videos = @level.videos

    seen_videos = session[:videos_seen] || Set.new()
    @videos.each do |v|
      if !seen_videos.include?(v.key)
        @autoplay_video_info = params[:noautoplay] ? nil : video_info(v)
        seen_videos.add(v.key)
        session[:videos_seen] = seen_videos
        break
      end
    end

    @toolbox_blocks = @toolbox_blocks || @level.toolbox_blocks
    @start_blocks = initial_blocks(current_user, @level) || @start_blocks || @level.start_blocks

    select_and_remember_callouts if @script_level
  end

  def select_and_remember_callouts
    session[:callouts_seen] ||= Set.new()
    @callouts_to_show = Callout.where(script_level: @script_level)
      .select(:id, :element_id, :qtip_config, :localization_key)
      .reject { |c| session[:callouts_seen].include?(c.localization_key) }
      .each { |c| session[:callouts_seen].add(c.localization_key) }
    @callouts = make_localized_hash_of_callouts(@callouts_to_show)
  end

  def make_localized_hash_of_callouts(callouts)
    callouts.map do |callout|
      callout_hash = callout.attributes
      callout_hash.delete('localization_key')
      callout_hash['localized_text'] = data_t('callout.text', callout.localization_key)
      callout_hash
    end
  end

  # this defines which levels should be seeded with th last result from a different level
  def initial_blocks(user, level)
    if params[:initial_code]
      return params[:initial_code]
    end

    if user
      if level.game.app == 'turtle'
        from_level_num = case level.level_num
          when '3_8' then '3_7'
          when '3_9' then '3_8'
        end

        if from_level_num
          from_level = Level.find_by_game_id_and_level_num(level.game_id, from_level_num)
          return user.last_attempt(from_level).try(:level_source).try(:data)
        end
      end
    end
    nil
  end

  # XXX Since Blockly doesn't play nice with the asset pipeline, a query param
  # must be specified to bust the CDN cache. CloudFront is enabled to forward
  # query params. Don't cache bust during dev, so breakpoints work.
  # See where ::CACHE_BUST is initialized for more details.
  def blockly_cache_bust
    if ::CACHE_BUST.blank?
      false
    else
      ::CACHE_BUST
    end
  end


  def show_image(params)
    if params[:id]
      level_source = LevelSource.find(params[:id])
      app = level_source.level.game.app
    else
      app = params[:app]
    end

    if app == 'flappy'
      request.protocol + request.host_with_port + ActionController::Base.helpers.asset_path('flappy_sharing_drawing.png')
    elsif app == 'bounce'
      request.protocol + request.host_with_port + ActionController::Base.helpers.asset_path('bounce_sharing_drawing.png')    
    else
      level_source_image = LevelSourceImage.find_by_level_source_id(level_source.id)
      if !level_source_image.nil? && !level_source_image.image.nil?
        url_for(:controller => "level_sources", :action => "generate_image", :id => params[:id], only_path: false)
      else
        request.protocol + request.host_with_port + ActionController::Base.helpers.asset_path('sharing_drawing.png')
      end
    end
  end
end
