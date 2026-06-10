require "test_helper"

module Api
  module V1
    class SessionsControllerTest < ActionDispatch::IntegrationTest
      test "login com credenciais válidas retorna usuário e token JWT" do
        post api_v1_login_url, params: {
          user: { email: users(:one).email, password: "12345678" }
        }, as: :json

        assert_response :success
        body = JSON.parse(response.body)
        assert_equal "Login realizado com sucesso.", body["message"]
        assert_equal users(:one).email, body["user"]["email"]
        assert response.headers["Authorization"].present?
      end

      test "login com credenciais inválidas retorna 401 em JSON" do
        post api_v1_login_url, params: {
          user: { email: users(:one).email, password: "senha-errada" }
        }, as: :json

        assert_response :unauthorized
        body = JSON.parse(response.body)
        assert body["error"].present?
      end

      test "logout revoga o token JWT" do
        post api_v1_login_url, params: {
          user: { email: users(:one).email, password: "12345678" }
        }, as: :json

        token = response.headers["Authorization"]

        delete api_v1_logout_url, headers: { "Authorization" => token }, as: :json
        assert_response :success

        get api_v1_me_url, headers: { "Authorization" => token }, as: :json
        assert_response :unauthorized
      end
    end
  end
end
