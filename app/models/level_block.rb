class LevelBlock < ActiveRecord::Base
  belongs_to :block
  belongs_to :level
end
