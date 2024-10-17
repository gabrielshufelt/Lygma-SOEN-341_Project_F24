class Course < ApplicationRecord
  validates :title, presence: true
  validates :code, presence: true, uniqueness: true
end
