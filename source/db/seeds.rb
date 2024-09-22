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