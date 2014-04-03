class ScriptLevel < ActiveRecord::Base
  belongs_to :level
  belongs_to :script
  belongs_to :stage
  acts_as_list scope: :stage

  NEXT = 'next'

  # this is
  attr_accessor :user_level

  def next_level
    if self.stage
      self.higher_item
    else
      self.script.try(:get_script_level_by_chapter, self.chapter + 1)
    end
  end

  def previous_level
    if self.stage
      self.lower_item
    else
      self.script.try(:get_script_level_by_chapter, self.chapter - 1)
    end
  end

  def self.cache_find(id)
    @@script_level_map ||= ScriptLevel.includes(:level, :script).index_by(&:id)
    @@script_level_map[id]
  end
end
