require "test_helper"

module Api
  module V1
    class PostsControllerTest < ActionDispatch::IntegrationTest
      setup do
        [ users(:one), users(:two) ].each do |user|
          user.roles.destroy_all
          user.add_role(:user)
        end
      end

      test "index lista posts autenticado" do
        get api_v1_posts_url, headers: auth_headers(users(:one)), as: :json

        assert_response :success
        body = JSON.parse(response.body)
        assert body["posts"].size >= 1
      end

      test "create associa post ao usuário autenticado" do
        assert_difference "Post.count", 1 do
          post api_v1_posts_url,
               params: { post: { title: "Novo post", body: "Conteúdo" } },
               headers: auth_headers(users(:one)),
               as: :json
        end

        assert_response :created
        body = JSON.parse(response.body)
        assert_equal "Novo post", body["post"]["title"]
        assert_equal users(:one).id, body["post"]["user_id"]
      end

      test "update por outro usuário retorna 403" do
        post_record = posts(:one)

        patch api_v1_post_url(post_record),
              params: { post: { title: "Tentativa" } },
              headers: auth_headers(users(:two)),
              as: :json

        assert_response :forbidden
      end

      test "admin pode atualizar post de outro usuário" do
        users(:two).promote_to_admin!
        post_record = posts(:one)

        patch api_v1_post_url(post_record),
              params: { post: { title: "Editado pelo admin" } },
              headers: auth_headers(users(:two)),
              as: :json

        assert_response :success
        assert_equal "Editado pelo admin", post_record.reload.title
      end

      test "destroy remove post do próprio usuário" do
        post_record = posts(:one)

        assert_difference "Post.count", -1 do
          delete api_v1_post_url(post_record),
                 headers: auth_headers(users(:one)),
                 as: :json
        end

        assert_response :no_content
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
