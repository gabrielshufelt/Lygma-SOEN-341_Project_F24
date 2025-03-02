# Erase all data
Evaluation.delete_all

# Create Example Instructor
instructor1 = User.find_or_initialize_by(email: 'john@example.com')
instructor1.update!(
  password: 'to0muC4$4uC3',
  first_name: 'John',
  last_name: 'Daquavious',
  role: 'instructor',
  sex: 'male',
  birth_date: Date.new(1980, 5, 15)
)

instructor2 = User.find_or_initialize_by(email: 'steve@example.com')
instructor2.update!(
  password: 'g00dpa$$w0rd',
  first_name: 'Steve',
  last_name: 'Brown',
  role: 'instructor',
  sex: 'male',
  birth_date: Date.new(1975, 8, 22)
)

# Create Example Students
student1 = User.find_or_initialize_by(email: 'alice@example.com')
student1.update!(
  password: 'a1b2c3d4e5f6',
  first_name: 'Alice',
  last_name: 'Johnson',
  role: 'student',
  cooperation_rating: 4.5,
  conceptual_rating: 4.2,
  practical_rating: 6.9,
  work_ethic_rating: 4.7,
  sex: 'female',
  birth_date: Date.new(2000, 3, 10),
  student_id: '40247001'
)

student2 = User.find_or_initialize_by(email: 'bob@example.com')
student2.update!(
  password: 'f6e5d4c3b2a1',
  first_name: 'Bob',
  last_name: 'Smith',
  role: 'student',
  cooperation_rating: 0.0,
  conceptual_rating: 0.0,
  practical_rating: 0.0,
  work_ethic_rating: 0.0,
  sex: 'male',
  birth_date: Date.new(1999, 7, 25),
  student_id: '40247002'
)

student3 = User.find_or_initialize_by(email: 'carol@example.com')
student3.update!(
  password: 'p4ssword12345',
  first_name: 'Carol',
  last_name: 'Anderson',
  role: 'student',
  cooperation_rating: 6.8,
  conceptual_rating: 6.5,
  practical_rating: 5.1,
  work_ethic_rating: 4.0,
  sex: 'female',
  birth_date: Date.new(2001, 11, 5),
  student_id: '40247003'
)

student4 = User.find_or_initialize_by(email: 'dave@example.com')
student4.update!(
  password: 's3cr3tp4ssword',
  first_name: 'Dave',
  last_name: 'Williams',
  role: 'student',
  cooperation_rating: 4.9,
  conceptual_rating: 5.7,
  practical_rating: 6.3,
  work_ethic_rating: 4.8,
  sex: 'male',
  birth_date: Date.new(2000, 2, 20),
  student_id: '40247004'
)

student5 = User.find_or_initialize_by(email: 'eve@example.com')
student5.update!(
  password: 'p@ssw0rd09876',
  first_name: 'Eve',
  last_name: 'Taylor',
  role: 'student',
  cooperation_rating: 7.0,
  conceptual_rating: 7.0,
  practical_rating: 6.0,
  work_ethic_rating: 7.0,
  sex: 'female',
  birth_date: Date.new(2001, 6, 15),
  student_id: '40247005'
)

student6 = User.find_or_initialize_by(email: 'frank@example.com')
student6.update!(
  password: 'aBcD3FgH1JkL',
  first_name: 'Frank',
  last_name: 'Brown',
  role: 'student',
  cooperation_rating: 4.0,
  conceptual_rating: 6.8,
  practical_rating: 2.5,
  work_ethic_rating: 6.6,
  sex: 'male',
  birth_date: Date.new(1998, 12, 30),
  student_id: '40247006'
)

# Create additional students not enrolled in any courses
student7 = User.find_or_initialize_by(email: 'grace@example.com')
student7.update!(
  password: 'grace12345',
  first_name: 'Grace',
  last_name: 'Hopper',
  role: 'student',
  sex: 'female',
  birth_date: Date.new(2002, 1, 1),
  student_id: '40247007'
)

student8 = User.find_or_initialize_by(email: 'heidi@example.com')
student8.update!(
  password: 'heidi12345',
  first_name: 'Heidi',
  last_name: 'Lamarr',
  role: 'student',
  sex: 'female',
  birth_date: Date.new(2001, 4, 15),
  student_id: '40247008'
)

student9 = User.find_or_initialize_by(email: 'ivan@example.com')
student9.update!(
  password: 'ivan12345',
  first_name: 'Ivan',
  last_name: 'Sutherland',
  role: 'student',
  sex: 'male',
  birth_date: Date.new(2000, 7, 20),
  student_id: '40247009'
)

student10 = User.find_or_initialize_by(email: 'judy@example.com')
student10.update!(
  password: 'judy12345',
  first_name: 'Judy',
  last_name: 'Blume',
  role: 'student',
  sex: 'female',
  birth_date: Date.new(1999, 10, 30),
  student_id: '40247010'
)

student11 = User.find_or_initialize_by(email: 'luqman@realratings.com')
student11.update!(
  password: 'real3st3va',
  first_name: 'Luqman',
  last_name: 'Hakim',
  role: 'student',
  sex: 'male',
  birth_date: Date.new(2000, 10, 31),
  student_id: '40247011'
 )

# Assign unique student_id to existing student users without one
User.where(role: 'student').each do |student|
  student.update(student_id: "40#{rand(1_000_000..9_999_999)}") unless student.student_id.present?
end

course1 = Course.find_or_initialize_by(code: 'SOEN 341')
course1.update!(
  title: 'Software Process',
  instructor_id: instructor1.id
)

course2 = Course.find_or_initialize_by(code: 'ENGR 371')
course2.update!(
  title: 'Probability and Statistics',
  instructor_id: instructor1.id
)

course3 = Course.find_or_initialize_by(code: 'COMP 352')
course3.update!(
  title: 'Data Structures and Algorithms',
  instructor_id: instructor1.id
)

# Students enrolling in courses
course1.enroll([student1, student2, student3, student4, student5, student6])
course2.enroll([student2, student4, student6])
course3.enroll([student1, student2, student3, student4, student5, student6])

project1 = Project.find_or_initialize_by(id: 1)
project1.update!(title: 'Sprint 1', due_date: Date.new(2024, 9, 29), course_id: course1.id, maximum_team_size: 6)

project2 = Project.find_or_initialize_by(id: 2)
project2.update!(title: 'Sprint 2', due_date: Date.tomorrow, course_id: course1.id, maximum_team_size: 6)

team1 = Team.find_or_initialize_by(id: 1000)
team1.update!(name: 'Real Ratings', description: 'Providing Real Ratings for Real People', project_id: project1.id)

team2 = Team.find_or_initialize_by(id: 1001)
team2.update!(name: 'Fake Ratings', description: 'Providing Fake Ratings for Fake People', project_id: project1.id)

Evaluation.create!(
  [
    # Evaluations where Alice is the evaluatee
    { evaluator_id: student2.id, evaluatee_id: student1.id, status: 'completed', date_completed: 3.months.ago + 1.day, project_id: project1.id, team_id: team1.id, cooperation_rating: 4.5, conceptual_rating: 4.0, practical_rating: 4.7, work_ethic_rating: 4.9, comment: 'Excellent work!' },
    { evaluator_id: student3.id, evaluatee_id: student1.id, status: 'completed', date_completed: 3.months.ago + 3.days, project_id: project1.id, team_id: team1.id, cooperation_rating: 5.0, conceptual_rating: 5.5, practical_rating: 4.2, work_ethic_rating: 5.1, comment: 'Very good!' },
    { evaluator_id: student4.id, evaluatee_id: student1.id, status: 'completed', date_completed: 2.months.ago + 2.days, project_id: project1.id, team_id: team1.id, cooperation_rating: 3.0, conceptual_rating: 3.5, practical_rating: 4.0, work_ethic_rating: 4.5, comment: 'Could improve!' },
    { evaluator_id: student5.id, evaluatee_id: student1.id, status: 'completed', date_completed: 2.months.ago + 4.days, project_id: project1.id, team_id: team1.id, cooperation_rating: 6.0, conceptual_rating: 6.2, practical_rating: 6.5, work_ethic_rating: 6.7, comment: 'Great team player!' },
    { evaluator_id: student6.id, evaluatee_id: student1.id, status: 'completed', date_completed: 1.month.ago + 1.day, project_id: project1.id, team_id: team1.id, cooperation_rating: 4.8, conceptual_rating: 4.6, practical_rating: 4.7, work_ethic_rating: 4.9, comment: 'Nice contribution!' },
    { evaluator_id: student2.id, evaluatee_id: student1.id, status: 'completed', date_completed: 1.month.ago + 2.days, project_id: project1.id, team_id: team1.id, cooperation_rating: 5.0, conceptual_rating: 5.5, practical_rating: 5.0, work_ethic_rating: 5.2, comment: 'Good effort!' },
    { evaluator_id: student3.id, evaluatee_id: student1.id, status: 'completed', date_completed: 15.days.ago, project_id: project1.id, team_id: team1.id, cooperation_rating: 4.7, conceptual_rating: 4.8, practical_rating: 4.9, work_ethic_rating: 5.0, comment: 'Solid work!' },
    { evaluator_id: student5.id, evaluatee_id: student1.id, status: 'completed', date_completed: 8.days.ago, project_id: project2.id, team_id: team1.id, cooperation_rating: 6.7, conceptual_rating: 6.8, practical_rating: 6.9, work_ethic_rating: 7.0, comment: 'Exceptional contribution this sprint!'},
    { evaluator_id: student6.id, evaluatee_id: student1.id, status: 'completed', date_completed: 6.days.ago, project_id: project2.id, team_id: team1.id, cooperation_rating: 5.8, conceptual_rating: 6.0, practical_rating: 6.2, work_ethic_rating: 6.4, comment: 'Shows great leadership qualities!'},
    { evaluator_id: student2.id, evaluatee_id: student1.id, status: 'pending', project_id: project2.id, team_id: team1.id },

    # Evaluations where Alice is the evaluator
    { evaluator_id: student1.id, evaluatee_id: student2.id, status: 'pending', project_id: project1.id,
      team_id: team1.id },
    { evaluator_id: student1.id, evaluatee_id: student2.id, status: 'pending', project_id: project2.id,
      team_id: team1.id },
    { evaluator_id: student1.id, evaluatee_id: student3.id, status: 'pending', project_id: project2.id,
      team_id: team1.id },
    { evaluator_id: student1.id, evaluatee_id: student4.id, status: 'pending', project_id: project2.id,
      team_id: team1.id },
    { evaluator_id: student1.id, evaluatee_id: student5.id, status: 'pending', project_id: project2.id,
      team_id: team1.id }
  ]
)

team1.add_student(student1)
team1.add_student(student2)
team1.add_student(student3)
team1.add_student(student4)
team1.add_student(student5)
