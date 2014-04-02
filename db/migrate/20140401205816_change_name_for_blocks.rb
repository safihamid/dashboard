class ChangeNameForBlocks < ActiveRecord::Migration
  def change
    change_column :blocks, :name, :string, null: true
  end
end
