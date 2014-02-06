class AddSolutionToLevels < ActiveRecord::Migration
  def change
    add_column :levels, :solution, :string
  end
end
