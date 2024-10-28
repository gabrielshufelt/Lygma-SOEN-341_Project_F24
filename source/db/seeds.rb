# Create Example Instructor
instructor1 = User.find_or_initialize_by(email: "john@example.com")
instructor1.update!(
  password: "to0muC4$4uC3",
  first_name: "John",
  last_name: "Daquavious",
  role: "instructor",
  sex: 'male'
)

instructor2 = User.find_or_initialize_by(email: 'steve@example.com')
instructor2.update!(
  password: 'g00dpa$$w0rd',
  first_name: 'Steve',
  last_name: 'Brown',
  role: 'instructor',
  sex: 'male'
)

# Create Example Students
student1 = User.find_or_initialize_by(email: "alice@example.com")
student1.update!(
  password: "a1b2c3d4e5f6",
  first_name: "Alice",
  last_name: "Johnson",
  role: "student",
  cooperation_rating: 4.5,
  conceptual_rating: 4.2,
  practical_rating: 6.9,
  work_ethic_rating: 4.7,
  sex: 'female'
)

student2 = User.find_or_initialize_by(email: "bob@example.com")
student2.update!(
  password: "f6e5d4c3b2a1",
  first_name: "Bob",
  last_name: "Smith",
  role: "student",
  cooperation_rating: 0.0,
  conceptual_rating: 0.0,
  practical_rating: 0.0,
  work_ethic_rating: 0.0,
  sex: 'male'
)

student3 = User.find_or_initialize_by(email: "carol@example.com")
student3.update!(
  password: "p4ssword12345",
  first_name: "Carol",
  last_name: "Anderson",
  role: "student",
  cooperation_rating: 6.8,
  conceptual_rating: 6.5,
  practical_rating: 5.1,
  work_ethic_rating: 4.0,
  sex: 'female'
)

student4 = User.find_or_initialize_by(email: "dave@example.com")
student4.update!(
  password: "s3cr3tp4ssword",
  first_name: "Dave",
  last_name: "Williams",
  role: "student",
  cooperation_rating: 4.9,
  conceptual_rating: 5.7,
  practical_rating: 6.3,
  work_ethic_rating: 4.8,
  sex:'male'
)

student5 = User.find_or_initialize_by(email: "eve@example.com")
student5.update!(
  password: "p@ssw0rd09876",
  first_name: "Eve",
  last_name: "Taylor",
  role: "student",
  cooperation_rating: 7.0,
  conceptual_rating: 7.0,
  practical_rating: 6.0,
  work_ethic_rating: 7.0,
  sex: 'female'
)


student6 = User.find_or_initialize_by(email: "frank@example.com")
student6.update!(
  password: "aBcD3FgH1JkL",
  first_name: "Frank",
  last_name: "Brown",
  role: "student",
  cooperation_rating: 4.0,
  conceptual_rating: 6.8,
  practical_rating: 2.5,
  work_ethic_rating: 6.6,
  sex: 'male'
)

course1 = Course.find_or_initialize_by(code: "SOEN 341")
course1.update!(
  title: "Software Process",
  instructor_id: instructor1.id
)

course2 = Course.find_or_initialize_by(code: "ENGR 371")
course2.update!(
  title: "Probability and Statistics",
  instructor_id: instructor1.id
)

course3 = Course.find_or_initialize_by(code: "COMP 352")
course3.update!(
  title: "Data Structures and Algorithms",
  instructor_id: instructor1.id
)

# Students enrolling in courses
course1.students << [student1, student2, student5, student6]
course2.students << [student2, student4, student6]
course3.students << [student1, student2, student3, student4, student5, student6]

project1 = Project.find_or_initialize_by(id: 1)
project1.update!(
  title: "Sprint 1",
  due_date: Date.new(2024, 9, 29),
  course_id: course1.id,
  maximum_team_size: 6
)

team1 = Team.find_or_initialize_by(id: 1000)
team1.update!(
  name: "Real Ratings",
  description: "Providing Real Ratings for Real People",
  project_id: project1.id
)

evaluation1 = Evaluation.find_or_initialize_by(evaluator_id: student1.id)
evaluation1.update!(
  status: "completed", 
  date_completed: "2022-09-21", 
  project_id: project1.id,
  evaluator_id: student1.id,
  evaluatee_id: student2.id,
  team_id: team1.id,
  cooperation_rating: 4.0, 
  conceptual_rating: 4.0, 
  practical_rating: 4.0, 
  work_ethic_rating: 4.0, 
  comment: "Great job!"
)

team1.students << [student1, student2, student3]