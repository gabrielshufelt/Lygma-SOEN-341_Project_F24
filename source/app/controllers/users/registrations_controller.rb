class Users::RegistrationsController < Devise::RegistrationsController
  before_action :configure_permitted_parameters, if: :devise_controller?

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:first_name, :last_name, :role, :team_id])
    devise_parameter_sanitizer.permit(:account_update, keys: [:first_name, :last_name, :role, :team_id, :cooperation_rating, :conceptual_rating, :practical_rating, :work_ethic_rating])
  end
end
