module Api
  module V1
    class BaseController < ActionController::API
      respond_to :json

      before_action :authenticate_user!

      private

      def require_admin!
        return true if current_user&.admin?

        render json: { error: "Acesso negado." }, status: :forbidden
        false
      end

      def user_payload(user)
        {
          id: user.id,
          email: user.email,
          display_name: user.display_name,
          roles: user.roles.pluck(:name)
        }
      end
    end
  end
end
