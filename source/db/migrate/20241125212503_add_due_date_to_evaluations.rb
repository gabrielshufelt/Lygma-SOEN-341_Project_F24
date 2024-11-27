class AddDueDateToEvaluations < ActiveRecord::Migration[7.1]
  def change
    add_column :evaluations, :due_date, :date
  end
end
