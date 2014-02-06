class AddCustomGame < ActiveRecord::Migration
  def change
    Game.create!(:name => "Custom", :app => "turtle")
  end
end
