class AddInstructorIdToUsers < ActiveRecord::Migration[7.1]
  def change
    add_column :users, :instructor_id, :integer
  end
end
