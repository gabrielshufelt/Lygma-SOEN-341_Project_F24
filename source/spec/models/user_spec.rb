require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'validations' do
    it 'is invalid without all necessary fields' do
      user = User.new
      expect(user).not_to be_valid
      expect(user.errors[:first_name]).to include("can't be blank")
      expect(user.errors[:last_name]).to include("can't be blank")
      expect(user.errors[:email]).to include("can't be blank")
      expect(user.errors[:password]).to include("can't be blank")
      expect(user.errors[:role]).to include("can't be blank")
      expect(user.errors[:sex]).to include("can't be blank")
    end

    it 'does not allow an instructor to have ratings' do
      instructor = User.new(role: 'instructor', first_name: 'John', last_name: 'Doe', email: 'instructor@example.com',
                            password: 'password', sex: 'female')
      instructor.cooperation_rating = 5
      instructor.valid? # Ensure validation is called
      expect(instructor.errors[:base]).to include('Instructors cannot have ratings')
    end
  end
end
