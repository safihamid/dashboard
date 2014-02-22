class LevelNameCannotBeNull < ActiveRecord::Migration
  def change
    change_column :levels, :name, :string, :null => false
  end
end
