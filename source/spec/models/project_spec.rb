require 'rails_helper'
require 'faker'

RSpec.describe Project, type: :model do
  # Test for presence validation
  it 'is invalid without all necessary fields' do
    project = Project.new
    expect(project).not_to be_valid
    expect(project.errors[:title]).to include("can't be blank")
    expect(project.errors[:due_date]).to include("can't be blank")
    expect(project.errors[:course_id]).to include("can't be blank")
  end
end
