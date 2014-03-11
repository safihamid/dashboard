class CreateLevelBlock < ActiveRecord::Migration
  def change
    create_table :level_blocks do |t|
      t.references :level, null: false
      t.references :block, null: false
      t.string :type

      t.timestamps
    end

  end
end
