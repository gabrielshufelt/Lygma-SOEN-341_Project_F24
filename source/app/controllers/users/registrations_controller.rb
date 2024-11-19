class Users::RegistrationsController < Devise::RegistrationsController
  before_action :configure_permitted_parameters, if: :devise_controller?
  before_action :clean_student_id

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:first_name, :last_name, :role, :sex, :student_id])
    devise_parameter_sanitizer.permit(:account_update, keys: [:first_name, :last_name, :role, :cooperation_rating, :conceptual_rating, :practical_rating, :work_ethic_rating, :sex, :student_id])
  end

  private

  def clean_student_id
    if params[:user][:student_id].present?
      params[:user][:student_id] = params[:user][:student_id].to_s.strip.gsub(/\D/, '').to_i
    end
  end
end
