# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end

# just a model to test the seeds
Evaluation.create!([
    {status: "completed", date_completed: "2022-09-21", project_id: 1, student_id: 1, cooperation_rating: 4.0, conceptual_rating: 4.0, practical_rating: 4.0, work_ethic_rating: 4.0, comment: "Great job!"},
])

# Create Example Students
user1 = User.find_or_create_by(email: "alice@example.com") do |user|
  user.password = "a1b2c3d4e5f6"
  user.first_name = "Alice"
  user.last_name = "Johnson"
  user.role = "student"
  user.team_id = 1000
  user.cooperation_rating = 4.5
  user.conceptual_rating = 4.2
  user.practical_rating = 6.9
  user.work_ethic_rating = 4.7
end

user2 = User.find_or_create_by(email: "bob@example.com") do |user|
  user.password = "f6e5d4c3b2a1"
  user.first_name = "Bob"
  user.last_name = "Smith"
  user.role = "student"
  user.team_id = 1000
  user.cooperation_rating = 0.0
  user.conceptual_rating = 0.0
  user.practical_rating = 0.0
  user.work_ethic_rating = 0.0
end

user3 = User.find_or_create_by(email: "carol@example.com") do |user|
  user.password = "p4ssword12345"
  user.first_name = "Carol"
  user.last_name = "Anderson"
  user.role = "student"
  user.team_id = 1000
  user.cooperation_rating = 6.8
  user.conceptual_rating = 6.5
  user.practical_rating = 5.1
  user.work_ethic_rating = 4.0
end

user4 = User.find_or_create_by(email: "dave@example.com") do |user|
  user.password = "s3cr3tp4ssword"
  user.first_name = "Dave"
  user.last_name = "Williams"
  user.role = "student"
  user.team_id = 1000
  user.cooperation_rating = 4.9
  user.conceptual_rating = 5.7
  user.practical_rating = 6.3
  user.work_ethic_rating = 4.8
end

user5 = User.find_or_create_by(email: "eve@example.com") do |user|
  user.password = "p@ssw0rd09876"
  user.first_name = "Eve"
  user.last_name = "Taylor"
  user.role = "student"
  user.team_id = 1000
  user.cooperation_rating = 7.0
  user.conceptual_rating = 7.0
  user.practical_rating = 6.0
  user.work_ethic_rating = 7.0
end

user6 = User.find_or_create_by(email: "frank@example.com") do |user|
  user.password = "aBcD3FgH1JkL"
  user.first_name = "Frank"
  user.last_name = "Brown"
  user.role = "student"
  user.team_id = 1000
  user.cooperation_rating = 4.0
  user.conceptual_rating = 6.8
  user.practical_rating = 2.5
  user.work_ethic_rating = 6.6
end

# Create Example Instructor
user7 = User.find_or_create_by(email: "john@example.com") do |user|
  user.password = "to0muC4$4uC3"
  user.first_name = "John"
  user.last_name = "Daquavious"
  user.role = "instructor"
end

