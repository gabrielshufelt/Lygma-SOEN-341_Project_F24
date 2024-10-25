class AddMaximumTeamSizeToProjects < ActiveRecord::Migration[7.1]
  def change
    add_column :projects, :maximum_team_size, :integer
  end
end
