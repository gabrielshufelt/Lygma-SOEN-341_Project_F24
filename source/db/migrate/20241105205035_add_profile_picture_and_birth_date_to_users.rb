class AddProfilePictureAndBirthDateToUsers < ActiveRecord::Migration[7.1]
  def change
    add_column :users, :birth_date, :date, default: nil
    add_column :users, :profile_picture, :string, default: nil
  end
end
