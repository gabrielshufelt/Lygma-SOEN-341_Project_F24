class UpdateEvaluationsFields < ActiveRecord::Migration[7.1]
  def change
    change_column_null :evaluations, :cooperation_rating, true
    change_column_null :evaluations, :conceptual_rating, true
    change_column_null :evaluations, :practical_rating, true
    change_column_null :evaluations, :work_ethic_rating, true
    change_column_null :evaluations, :date_completed, true

    # change default value for status to 'pending'
    change_column_default :evaluations, :status, 'pending'
  end
end
