class AddLearningInsightsToUsers < ActiveRecord::Migration[7.1]
  def change
    add_column :users, :learning_insights, :text
    add_column :users, :insights_updated_at, :datetime
  end
end
