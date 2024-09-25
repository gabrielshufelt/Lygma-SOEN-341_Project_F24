require 'rails_helper'
require 'faker'

RSpec.describe Team, type: :model do
  let(:instructor) { User.create!(role: "instructor", first_name: "John", last_name: "Doe", email: "instructor@example.com", password: "password") }

  # Test for presence validation
  it 'is invalid without all necessary fields' do
    team = Team.new(name: nil, instructor: nil)
    expect(team).not_to be_valid
    expect(team.errors[:name]).to include("can't be blank")
    expect(team.errors[:instructor_id]).to include("can't be blank")  # Add this expectation
  end
end
