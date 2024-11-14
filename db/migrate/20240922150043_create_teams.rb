class CreateTeams < ActiveRecord::Migration[7.1]
  def change
    create_table :teams do |t|
      t.string :name
      t.string :course_name
      t.integer :instructor_id

      t.timestamps
    end
  end
end
