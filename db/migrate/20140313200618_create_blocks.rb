class CreateBlocks < ActiveRecord::Migration
  def change
    create_table :blocks do |t|
      t.string :name
      t.string :xml, limit: 20000

      t.timestamps
    end
  end
end
