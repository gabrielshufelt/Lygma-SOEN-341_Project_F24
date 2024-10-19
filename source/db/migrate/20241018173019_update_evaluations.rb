class UpdateEvaluations < ActiveRecord::Migration[7.1]
  def change
    rename_column :evaluations, :student_id, :evaluatee_id

    add_reference :evaluations, :evaluator, null: false, foreign_key: { to_table: :users }
    add_reference :evaluations, :team, null: false, foreign_key: true

    add_foreign_key :evaluations, :projects, column: :project_id
    add_foreign_key :evaluations, :users, column: :evaluatee_id
  end
end
