class ActivityHint < ActiveRecord::Base
  belongs_to :activity
  belongs_to :level_source_hint
end
