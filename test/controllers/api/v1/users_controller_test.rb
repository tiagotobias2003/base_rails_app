require "test_helper"

module Api
  module V1
    class UsersControllerTest < ActionDispatch::IntegrationTest
      setup do
        users(:one).roles.destroy_all
        users(:one).add_role(:user)
        users(:two).roles.destroy_all
        users(:two).add_role(:admin)
      end

      test "me retorna o usuário autenticado" do
        post api_v1_login_url, params: {
          user: { email: users(:one).email, password: "12345678" }
        }, as: :json

        token = response.headers["Authorization"]

        get api_v1_me_url, headers: { "Authorization" => token }, as: :json

        assert_response :success
        body = JSON.parse(response.body)
        assert_equal users(:one).email, body["user"]["email"]
      end

      test "me sem token retorna 401" do
        get api_v1_me_url, as: :json

        assert_response :unauthorized
      end

      test "index negado para usuário comum" do
        get api_v1_users_url, headers: auth_headers(users(:one)), as: :json
        assert_response :forbidden
      end

      test "index lista usuários para admin" do
        headers = auth_headers(users(:two))
        assert users(:two).reload.admin?

        get api_v1_users_url, headers: headers, as: :json
        assert_response :success

        body = JSON.parse(response.body)
        assert body["users"].size >= 2
      end

      test "admin pode promover usuário" do
        patch role_api_v1_user_url(users(:one)),
              params: { role: "admin" },
              headers: auth_headers(users(:two)),
              as: :json

        assert_response :success
        assert users(:one).reload.admin?
      end

      test "admin pode rebaixar usuário" do
        users(:one).promote_to_admin!

        patch role_api_v1_user_url(users(:one)),
              params: { role: "user" },
              headers: auth_headers(users(:two)),
              as: :json

        assert_response :success
        assert_not users(:one).reload.admin?
      end

      test "usuário comum não pode alterar roles" do
        patch role_api_v1_user_url(users(:two)),
              params: { role: "user" },
              headers: auth_headers(users(:one)),
              as: :json

        assert_response :forbidden
      end

      private

      def auth_headers(user)
        post api_v1_login_url, params: {
          user: { email: user.email, password: "12345678" }
        }, as: :json

        { "Authorization" => response.headers["Authorization"] }
      end
    end
  end
end
