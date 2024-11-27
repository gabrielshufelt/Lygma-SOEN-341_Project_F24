class CreateEvaluations < ActiveRecord::Migration[7.1]
  # added null: false to all columns except comment, also changed comment to t.text
  # lmk if this isn't what you wanted gibreeeel
  def change
    create_table :evaluations do |t|
      t.string :status, null: false, default: 'pending'
      t.date :date_completed, null: false
      t.integer :project_id, null: false
      t.integer :student_id, null: false
      t.float :cooperation_rating, null: false
      t.float :conceptual_rating, null: false
      t.float :practical_rating, null: false
      t.float :work_ethic_rating, null: false
      t.text :comment

      t.timestamps
    end
  end
end
