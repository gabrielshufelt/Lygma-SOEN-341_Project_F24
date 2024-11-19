class SettingsUpdateService
  def self.update(user, settings_params)
    new(user, settings_params).execute
  end

  def initialize(user, settings_params)
    @user = user
    @settings_params = settings_params
  end

  def execute
    if @settings_params[:password].present?
      result = update_password
      return result if result[:redirect] == :logout # Stop here if logout is required
    end

    handle_profile_picture
    update_basic_info
  end

  private

  def update_password
    if @user.update_with_password(@settings_params)
      { notice: "Password updated successfully. Please log in again.", redirect: :logout }
    else
      { alert: "Failed to update password: #{@user.errors.full_messages.join(', ')}" }
    end
  end

  def handle_profile_picture
    # Check if the profile picture should be removed
    if @settings_params[:remove_profile_picture] == '1'
      @user.profile_picture.purge if @user.profile_picture.attached?
    elsif @settings_params[:profile_picture].present?
      @user.profile_picture.attach(@settings_params[:profile_picture])
    end
  end

  def update_basic_info
    filtered_params = @settings_params.except(:password, :current_password, :remove_profile_picture).to_h.reject { |_, v| v.blank? }

    if @user.update(filtered_params)
      { notice: "Settings updated successfully." }
    else
      { alert: "Failed to update settings: #{@user.errors.full_messages.join(', ')}" }
    end
  end
end
