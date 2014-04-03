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
  def complete_toolbox
    @@complete_toolbox ||= '<xml id="toolbox" style="display: none;"> <block type="maze_moveForward"></block> <block type="maze_turn"><title name="DIR">turnLeft</title></block> <block type="maze_turn"><title name="DIR">turnRight</title></block> <block type="maze_forever"></block> <block type="maze_if"><title name="DIR">isPathLeft</title></block> <block type="maze_if"></block> <block type="maze_ifElse"></block> <block type="controls_repeat"> <title name="TIMES">5</title> </block> <block type="maze_forever"></block> <block type="maze_if"><title name="DIR">isPathLeft</title></block> <block type="maze_if"><title name="DIR">isPathRight</title></block> <block type="maze_ifElse"></block> </xml>'
  end
end
