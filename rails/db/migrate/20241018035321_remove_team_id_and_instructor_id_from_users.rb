class RemoveTeamIdAndInstructorIdFromUsers < ActiveRecord::Migration[7.1]
  def change
    remove_column :users, :team_id, :integer
    remove_column :users, :instructor_id, :integer
  end
end
