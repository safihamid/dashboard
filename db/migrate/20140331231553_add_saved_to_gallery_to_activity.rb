class AddSavedToGalleryToActivity < ActiveRecord::Migration
  def change
    add_column :activities, :saved_to_gallery, :boolean
    add_index :activities, [:user_id, :saved_to_gallery]
  end
end
