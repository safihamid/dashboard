class CreateStages < ActiveRecord::Migration
  def change
    create_table :stages do |t|
      t.string :name
      t.integer :position
      t.references :script

      t.timestamps
    end
  end
end
