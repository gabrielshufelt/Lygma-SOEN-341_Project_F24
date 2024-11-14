class AddInstructorIdToCourses < ActiveRecord::Migration[7.0]
  def change
    add_column :courses, :instructor_id, :integer
    add_foreign_key :courses, :users, column: :instructor_id
  end
end
