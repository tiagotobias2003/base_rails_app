class Users::RegistrationsController < Devise::RegistrationsController
  layout :resolve_layout

  protected

  def resolve_layout
    action_name.in?(%w[edit update]) && user_signed_in? ? "application" : "devise"
  end

  def after_update_path_for(_resource)
    edit_user_registration_path
  end
end
