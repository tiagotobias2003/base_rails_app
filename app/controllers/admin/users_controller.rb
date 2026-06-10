module Admin
  class UsersController < BaseController
    before_action :set_user, only: %i[ promote demote ]

    def index
      @users = User.includes(:roles, :profile).order(:email)
    end

    def promote
      if @user == current_user
        redirect_to admin_users_path, alert: "Você já é administrador."
        return
      end

      @user.promote_to_admin!
      redirect_to admin_users_path, notice: "#{@user.display_name} promovido(a) a administrador."
    end

    def demote
      if @user == current_user
        redirect_to admin_users_path, alert: "Você não pode remover sua própria role de administrador."
        return
      end

      if @user.last_admin?
        redirect_to admin_users_path, alert: "Não é possível remover o último administrador."
        return
      end

      @user.demote_to_user!
      redirect_to admin_users_path, notice: "Role de administrador removida de #{@user.display_name}."
    end

    private

    def set_user
      @user = User.find(params.expect(:id))
    end
  end
end
