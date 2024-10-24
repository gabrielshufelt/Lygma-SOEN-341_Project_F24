class ApplicationController < ActionController::Base
  before_action :sign_out_on_public_pages

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

  private

  # Force sign-out on certain public pages
  def sign_out_on_public_pages
    public_pages = [about_pages_path, contact_pages_path, home_pages_path]

    if user_signed_in? && public_pages.include?(request.path)
      sign_out(current_user)
      redirect_to root_path, alert: 'You have been signed out.'
    end
  end
end
