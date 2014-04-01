class Level < ActiveRecord::Base
  has_many :start_level_blocks
  has_many :blocks, through: :start_level_blocks

  has_many :toolbox_level_blocks
  has_many :blocks, through: :toolbox_level_blocks

  belongs_to :game
  has_and_belongs_to_many :concepts
  belongs_to :solution_level_source, :class_name => "LevelSource"
  belongs_to :user
  #accepts_nested_attributes_for :concepts

  BUILDER = self.find_by_name('builder')

  validates_length_of :name, within: 1..70

  def videos
    ([game.intro_video] + concepts.map(&:video)).reject(&:nil?)
  end
end
