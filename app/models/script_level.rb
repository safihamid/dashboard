class ScriptLevel < ActiveRecord::Base
  belongs_to :level
  belongs_to :script

  WITHOUT_UNPLUGGED_QUERY = "script_levels.level_id IN (SELECT levels.id FROM levels JOIN games ON levels.game_id = games.id AND games.name NOT LIKE '%Unplug%')"
  scope :without_unplugged, ->{ where(WITHOUT_UNPLUGGED_QUERY).references(:games) }

  NEXT = 'next'

  # this is
  attr_accessor :user_level

  def next_level
    self.script.try(:get_script_level_by_chapter, self.chapter + 1)
  end

  def previous_level
    self.script.try(:get_script_level_by_chapter, self.chapter - 1)
  end

  def self.cache_find(id)
    @@script_level_map ||= ScriptLevel.includes(:level, :script).index_by(&:id)
    @@script_level_map[id]
  end
end
