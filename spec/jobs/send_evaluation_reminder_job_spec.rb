require 'rails_helper'

RSpec.describe SendEvaluationReminderJob, type: :job do
  let(:student_1) { User.create!(role: "student", first_name: "Jane", last_name: "Doe", email: "student@example.com", password: "password", sex: "male") }
  let(:student_2) { User.create!(role: "student", first_name: "Joe", last_name: "Smith", email: "student_2@example.com", password: "password", sex: "female") }
  let(:instructor) { User.create!(role: "instructor", first_name: "John", last_name: "Doe", email: "instructor@example.com", password: "password", sex: "male") }
  let(:project) { Project.create!(title: "Project 1", course_id: 1, maximum_team_size: 6, due_date: Date.tomorrow) }
  let!(:evaluation) { Evaluation.create!(status: 'pending', evaluator_id: student_1.id, evaluatee_id: student_2.id project_id: project.id) }

  it 'sends evaluation reminders to users with pending evaluations due tomorrow' do
    expect {
      SendEvaluationReminderJob.perform_now
    }.to change { ActionMailer::Base.deliveries.count }.by(1)

    mail = ActionMailer::Base.deliveries.last
    expect(mail.to).to include(user.email)
    expect(mail.subject).to eq('Reminder: Evaluations Due Tomorrow')
  end
end
