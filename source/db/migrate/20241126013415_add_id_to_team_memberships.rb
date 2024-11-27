class AddIdToTeamMemberships < ActiveRecord::Migration[7.1]
  def change
    add_column :team_memberships, :id, :primary_key
  end
end
