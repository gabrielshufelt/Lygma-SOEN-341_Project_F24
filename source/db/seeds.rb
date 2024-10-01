# Create Example Instructor
instructor1 = User.find_or_initialize_by(email: "john@example.com")
instructor1.update!(
  password: "to0muC4$4uC3",
  first_name: "John",
  last_name: "Daquavious",
  role: "instructor",
  sex: 'male'
)

# Create Example Students
student1 = User.find_or_initialize_by(email: "alice@example.com")
student1.update!(
  password: "a1b2c3d4e5f6",
  first_name: "Alice",
  last_name: "Johnson",
  role: "student",
  team_id: 1000,
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
  team_id: 1000,
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
  team_id: 1000,
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
  team_id: 1000,
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
  team_id: 1000,
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
  team_id: 1000,
  cooperation_rating: 4.0,
  conceptual_rating: 6.8,
  practical_rating: 2.5,
  work_ethic_rating: 6.6,
  sex: 'male'
)

team1 = Team.find_or_initialize_by(id: 1000)
team1.update!(
  name: "Real Ratings",
  course_name: "SOEN 341 - Software Process",
  instructor_id: instructor1.id
)

project1 = Project.find_or_initialize_by(id: 1)
project1.update!(
  title: "Sprint 1",
  team_id: team1.id,
  due_date: Date.new(2024, 9, 29),
  instructor_id: instructor1.id
)

evaluation1 = Evaluation.find_or_initialize_by(student_id: student1.id)
evaluation1.update!(
  status: "completed", 
  date_completed: "2022-09-21", 
  project_id: project1.id,
  student_id: student1.id,
  cooperation_rating: 4.0, 
  conceptual_rating: 4.0, 
  practical_rating: 4.0, 
  work_ethic_rating: 4.0, 
  comment: "Great job!"
)