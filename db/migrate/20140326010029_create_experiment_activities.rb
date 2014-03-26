class CreateExperimentActivities < ActiveRecord::Migration
  def change
    create_table :experiment_activities do |t|
      t.references :activity, null: false
      t.string :feedback_design, null: false

      t.timestamps
    end
  end
end
