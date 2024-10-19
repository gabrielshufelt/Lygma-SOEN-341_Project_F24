class RemoveTeamIdAndInstructorIdFromProjects < ActiveRecord::Migration[7.1]
  def change
    remove_column :projects, :team_id, :integer
    remove_column :projects, :instructor_id, :integer
  end
end
