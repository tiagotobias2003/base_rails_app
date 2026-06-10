module Api
  module V1
    class PostsController < BaseController
      before_action :set_post, only: %i[ show update destroy ]
      before_action :authorize_post!, only: %i[ update destroy ]

      def index
        posts = Post.includes(:user).order(created_at: :desc)
        render json: { posts: posts.map { |post| post_payload(post) } }
      end

      def show
        render json: { post: post_payload(@post) }
      end

      def create
        post = current_user.posts.build(post_params)

        if post.save
          render json: { post: post_payload(post) }, status: :created
        else
          render json: { errors: post.errors.full_messages }, status: :unprocessable_content
        end
      end

      def update
        if @post.update(post_params)
          render json: { post: post_payload(@post) }
        else
          render json: { errors: @post.errors.full_messages }, status: :unprocessable_content
        end
      end

      def destroy
        @post.destroy!
        head :no_content
      end

      private

      def set_post
        @post = Post.find(params[:id])
      rescue ActiveRecord::RecordNotFound
        render json: { error: "Post não encontrado." }, status: :not_found
      end

      def authorize_post!
        return if @post.user_id == current_user.id || current_user.admin?

        render json: { error: "Acesso negado." }, status: :forbidden
      end

      def post_params
        params.expect(post: [ :title, :body ])
      end

      def post_payload(post)
        {
          id: post.id,
          title: post.title,
          body: post.body,
          user_id: post.user_id,
          author: post.user.display_name,
          created_at: post.created_at,
          updated_at: post.updated_at
        }
      end
    end
  end
end
