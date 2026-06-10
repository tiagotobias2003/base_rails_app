module Api
  module V1
    # Login/logout da API. O token JWT é emitido pelo devise-jwt no header
    # Authorization da resposta do login e revogado no logout (JTIMatcher).
    class SessionsController < Devise::SessionsController
      skip_before_action :verify_authenticity_token
      respond_to :json

      # Evita layout HTML do Devise em respostas da API
      layout false

      private

      def respond_with(resource, _opts = {})
        render json: {
          message: "Login realizado com sucesso.",
          user: {
            id: resource.id,
            email: resource.email,
            display_name: resource.display_name,
            roles: resource.roles.pluck(:name)
          }
        }, status: :ok
      end

      def respond_to_on_destroy(non_navigational_status: :no_content)
        if request.headers["Authorization"].present?
          render json: { message: "Logout realizado com sucesso." }, status: :ok
        else
          render json: { error: "Token não informado." }, status: non_navigational_status
        end
      end
    end
  end
end
