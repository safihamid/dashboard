class AddBuilderLevel < ActiveRecord::Migration
  def change
    game = Game.find_by_name("Custom")
    Level.create!(:game => game, :name => "builder", :skin => "pvz", :level_num => "builder")
  end
end
