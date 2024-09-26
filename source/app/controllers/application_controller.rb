class ApplicationController < ActionController::Base
  # Redirect instructors to dashboard after sign in
  def after_sign_in_path_for(resource)
    if resource.instructor?
      instructor_dashboard_index_path  # Redirect instructors to the dashboard
    else
      root_path  # Redirect students to the home page
    end
  end

  # Use the same logic for sign up
  def after_sign_up_path_for(resource)
    after_sign_in_path_for(resource)
  end

  # Redirect all users to home page after signing out
  def after_sign_out_path_for(resource_or_scope)
    root_path
  end
end
