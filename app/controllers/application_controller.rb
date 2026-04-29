class ApplicationController < ActionController::Base
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern

  # Changes to the importmap will invalidate the etag for HTML responses
  stale_when_importmap_changes

  before_action :authenticate_user!

  # Define o layout base para as telas de autenticação
  layout :layout_by_resource

  protected

  # Define o layout base para as telas de autenticação
  def layout_by_resource
    if devise_controller?
      "devise"
    else
      "application"
    end
  end

end
