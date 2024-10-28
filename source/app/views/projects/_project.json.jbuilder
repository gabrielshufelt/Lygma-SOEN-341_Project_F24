json.extract! project, :id, :title, :description, :due_date, :maximum_team_size, :created_at, :updated_at
json.url project_url(project, format: :json)
