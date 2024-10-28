class AddMaximumTeamSizeToProjects < ActiveRecord::Migration[7.1]
  def change
    add_column :projects, :maximum_team_size, :integer, default: 6

    reversible do |dir|
      dir.up { Project.update_all(maximum_team_size: 6) }
    end
  end
end
