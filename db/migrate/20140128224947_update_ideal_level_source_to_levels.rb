class UpdateIdealLevelSourceToLevels < ActiveRecord::Migration
  def change
    Level.all.map do |level|
      best = Activity.where(level_id: level.id, test_result: 100).group(:level_source_id).max
      level.update_attributes(ideal_level_source_id: best.level_source.id) if best && best.level_source
    end
  end
end
