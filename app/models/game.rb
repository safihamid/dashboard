class Game < ActiveRecord::Base
  has_many :levels
  belongs_to :intro_video, foreign_key: 'intro_video_id', class_name: 'Video'

  def self.custom_maze
    @@game_custom_maze ||= find_by_name("CustomMaze")
  end

  def should_show_block? block
    block.apps.include?(self.app) || block.apps.include?('all')
  end
end
