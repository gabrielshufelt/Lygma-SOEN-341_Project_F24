class CreateJoinTableTeamMemberships < ActiveRecord::Migration[7.1]
  def change
    create_join_table :teams, :users, table_name: :team_memberships do |t|
      t.index :team_id 
      t.index :user_id
    end
  end
end
