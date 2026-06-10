module Admin
  module UsersHelper
    def user_role_badge(user)
      if user.admin?
        tag.span "Administrador", class: "inline-flex rounded-full bg-violet-100 px-2.5 py-0.5 text-xs font-medium text-violet-700 dark:bg-violet-900/40 dark:text-violet-300"
      else
        tag.span "Usuário", class: "inline-flex rounded-full bg-gray-100 px-2.5 py-0.5 text-xs font-medium text-gray-600 dark:bg-gray-800 dark:text-gray-300"
      end
    end
  end
end
