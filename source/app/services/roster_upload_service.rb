require 'csv'

class RosterUploadService
  REQUIRED_HEADERS = %w[first_name last_name email].freeze

  def initialize(file, course)
    @file = file
    @course = course
  end

  def call
    return { success: false, errors: ['No file uploaded'] } unless @file

    errors = []
    added = 0

    CSV.foreach(@file.path, headers: true) do |row|
      row_errors, student_added = process_row(row)
      errors.concat(row_errors)
      added += 1 if student_added
    end

    { success: errors.empty?, added:, errors: }
  end

  private

  def process_row(row)
    errors = check_headers(row.headers)
    return [errors, false] if errors.any?

    student = User.find_by(email: row['email'])
    errors.concat(check_student(student, row['email']))
    return [errors, false] if errors.any?

    @course.students << student
    [errors, true]
  end

  def check_headers(headers)
    errors = []
    if (missing_headers = REQUIRED_HEADERS - headers).any?
      errors << "Missing headers: #{missing_headers.join(', ')}"
    end
    errors
  end

  def check_student(student, email)
    errors = []
    if student
      errors << "Student #{email} is already enrolled in the course." if @course.students.include?(student)
    else
      errors << "Student #{email} does not exist."
    end
    errors
  end
end
