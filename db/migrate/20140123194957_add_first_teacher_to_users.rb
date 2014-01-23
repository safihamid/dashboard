class AddFirstTeacherToUsers < ActiveRecord::Migration
  def change
    add_reference :users, :first_teacher
  end
end
