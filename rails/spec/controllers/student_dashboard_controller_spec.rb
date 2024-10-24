require 'rails_helper'

RSpec.describe StudentDashboardController, type: :controller do
  let(:student) { 
  User.create!(
    role: "student", 
    first_name: "Jane", 
    last_name: "Doe", 
    email: "student@example.com", 
    password: "password", 
    sex: "male",
  ) 
}

let(:student_2) { 
  User.create!(
    role: "student", 
    first_name: "Joe", 
    last_name: "Smith", 
    email: "student_2@example.com", 
    password: "password", 
    sex: "female",
  ) 
}

let(:instructor) { 
  User.create!(
    role: "instructor", 
    first_name: "John", 
    last_name: "Doe", 
    email: "instructor@example.com", 
    password: "password", 
    sex: "male"
  ) 
}

let(:course) { 
  Course.create!(
    title: "Software Engineering Processes", 
    code: "SOEN341", 
    instructor: instructor
  ) 
}

let(:project) { 
  Project.create!(
    title: "Project Alpha", 
    description: "A project to test the peer assessment system.", 
    due_date: 1.week.from_now, 
    course: course
  ) 
}

let(:team) { 
  Team.create!(
    name: "Team A",
    project: project,
    description: "A team working on Project Alpha"
  )
}

let(:completed_evaluation) { 
  Evaluation.create!(
    evaluator: student, 
    evaluatee: student_2,
    project: project,
    team: team,
    conceptual_rating: 5.0, 
    cooperation_rating: 5.0, 
    practical_rating: 5.0, 
    work_ethic_rating: 5.0, 
    comment: "Good effort"
  ) 
}

let(:pending_evaluation) { 
  Evaluation.create!(
    evaluator: student_2, 
    evaluatee: student,
    project: project, 
    team: team,
    conceptual_rating: nil, 
    cooperation_rating: nil, 
    practical_rating: nil, 
    work_ethic_rating: nil, 
    comment: nil
  ) 
}
  before do
    sign_in student # Assuming Devise for authentication
    student.courses << course
  end

  describe "GET #index" do
    it "returns upcoming evaluations and average ratings" do
      allow_any_instance_of(StudentDashboardController).to receive(:upcoming_evaluations).and_return([pending_evaluation])
      allow_any_instance_of(StudentDashboardController).to receive(:avg_ratings).and_return({ conceptual: 4.5, cooperation: 4.0, practical: 3.5, work_ethic: 4.2 })

      get :index

      expect(response).to have_http_status(:ok)
      json_response = JSON.parse(response.body)
      expect(json_response['upcoming_evaluations']).to_not be_empty
      expect(json_response['avg_ratings']['conceptual']).to eq(4.5)
    end
  end

  describe "GET #teams" do
    it "returns student teams for their courses" do
      allow_any_instance_of(StudentDashboardController).to receive(:student_teams).and_return([{ project_id: project.id, student_team: nil, all_teams: [] }])

      get :teams

      expect(response).to have_http_status(:ok)
      json_response = JSON.parse(response.body)
      expect(json_response).to_not be_empty
    end
  end

  describe "GET #evaluations" do
    it "returns completed and pending evaluations for projects" do
      allow_any_instance_of(StudentDashboardController).to receive(:student_evaluations).and_return([{ project_id: project.id, completed: [completed_evaluation], pending: [pending_evaluation] }])

      get :evaluations

      expect(response).to have_http_status(:ok)
      json_response = JSON.parse(response.body)
      expect(json_response).to_not be_empty
    end
  end

  describe "GET #feedback" do
    it "returns average ratings and received evaluations" do
      allow_any_instance_of(StudentDashboardController).to receive(:avg_ratings).and_return({ conceptual: 4.5, cooperation: 4.0, practical: 3.5, work_ethic: 4.2 })
      allow_any_instance_of(StudentDashboardController).to receive(:received_evaluations).and_return([completed_evaluation])

      get :feedback

      expect(response).to have_http_status(:ok)
      json_response = JSON.parse(response.body)
      expect(json_response['avg_ratings']['conceptual']).to eq(4.5)
      expect(json_response['received_evaluations']).to_not be_empty
    end
  end
end