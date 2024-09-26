class AddSexToUsers < ActiveRecord::Migration[7.1]
  def change
    add_column :users, :sex, :string
  end
end
