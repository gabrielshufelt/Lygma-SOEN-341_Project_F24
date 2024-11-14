class TeamsService
  def initialize(course_id, student)
    @course_id = course_id
    @student = student
  end

  def teams_by_project
    projects = Project.where(course_id: @course_id)
    return [] if projects.empty?

    projects.map do |project|
      student_team = @student.teams.find_by(project_id: project.id)
      {
        project_title: project.title,
        student_team: student_team || nil,
        student_team_members: (student_team.members_to_string if student_team),
        all_teams: project.teams
      }
    end
  end
end
