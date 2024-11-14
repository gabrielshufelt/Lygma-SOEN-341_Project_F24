class CreateJoinTableCourseRegistrations < ActiveRecord::Migration[7.1]
  def change
    create_join_table :courses, :users, table_name: :course_registrations do |t|
      t.index :course_id
      t.index :user_id
    end
  end
end
