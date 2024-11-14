class AddDescriptionAndProjectIdToTeams < ActiveRecord::Migration[7.1]
  def change
    add_column :teams, :description, :text
    add_column :teams, :project_id, :integer
  end
end
