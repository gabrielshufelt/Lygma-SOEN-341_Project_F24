class CreateProjects < ActiveRecord::Migration[7.1]
  def change
    create_table :projects do |t|
      t.string :title
      t.text :description
      t.date :due_date
      t.integer :team_id
      t.integer :instructor_id

      t.timestamps
    end
  end
end
