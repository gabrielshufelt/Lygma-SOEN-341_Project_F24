class AddTeamCreationDeadlineToProjects < ActiveRecord::Migration[7.1]
  def change
    add_column :projects, :team_creation_deadline, :date
  end
end
