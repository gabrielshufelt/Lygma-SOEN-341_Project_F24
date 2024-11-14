class RemoveCourseNameAndInstructorIdFromTeams < ActiveRecord::Migration[7.1]
  def change
    remove_column :teams, :course_name, :string
    remove_column :teams, :instructor_id, :integer
  end
end
