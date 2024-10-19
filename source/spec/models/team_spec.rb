require 'rails_helper'
require 'faker'

RSpec.describe Team, type: :model do
  # Test for presence validation
  it 'is invalid without all necessary fields' do
    team = Team.new
    expect(team).not_to be_valid
    expect(team.errors[:name]).to include("can't be blank")
    expect(team.errors[:project_id]).to include("can't be blank")  # Add this expectation
  end
end
