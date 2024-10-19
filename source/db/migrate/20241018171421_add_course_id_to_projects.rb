class AddCourseIdToProjects < ActiveRecord::Migration[7.1]
  def change
    add_column :projects, :course_id, :integer
  end
end
