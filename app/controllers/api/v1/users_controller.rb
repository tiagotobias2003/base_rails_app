module Api
  module V1
    class UsersController < BaseController
      before_action :require_admin!, only: %i[ index update_role ]
      before_action :set_user, only: %i[ update_role ]

      # GET /api/v1/me
      def me
        render json: { user: user_payload(current_user) }
      end

      # GET /api/v1/users
      def index
        users = User.includes(:roles, :profile).order(:email)
        render json: { users: users.map { |user| user_payload(user) } }
      end

      # PATCH /api/v1/users/:id/role
      def update_role
        role = params.require(:role)

        case role
        when "admin"
          if @user == current_user
            return render json: { error: "Você já é administrador." }, status: :unprocessable_content
          end

          @user.promote_to_admin!
        when "user"
          if @user == current_user
            return render json: { error: "Você não pode remover sua própria role de administrador." }, status: :unprocessable_content
          end

          if @user.last_admin?
            return render json: { error: "Não é possível remover o último administrador." }, status: :unprocessable_content
          end

          @user.demote_to_user!
        else
          return render json: { error: "Role inválida. Use 'admin' ou 'user'." }, status: :unprocessable_content
        end

        render json: {
          message: "Role atualizada com sucesso.",
          user: user_payload(@user)
        }
      end

      private

      def set_user
        @user = User.find(params[:id])
      rescue ActiveRecord::RecordNotFound
        render json: { error: "Usuário não encontrado." }, status: :not_found
      end
    end
  end
end
