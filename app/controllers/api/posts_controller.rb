module Api
  class PostsController < ApiController
    before_action :set_post, only: [:show]

    # GET /posts
    api :GET, '/posts'
    def index
      @posts = User.where.not(id: current_api_user.blocked.map(&:id)).find_by!(email: params[:email]).posts

      render json: @posts
    end

    # GET /posts/1
    api :GET, '/posts/:id'
    param :id, :number, required: true
    def show
      render json: @post
    end

    # POST /posts
    api :POST, '/posts'
    param :post, Hash, :action_aware => true
    def create
      @post = Post.new(post_params.merge(user: current_api_user))

      if @post.save
        render json: @post, status: :created
      else
        render json: @post.errors, status: :unprocessable_entity
      end
    end

    private
      # Use callbacks to share common setup or constraints between actions.
      def set_post
        @post = Post.find(params[:id])
      end

      # Only allow a trusted parameter "white list" through.
      def post_params
        params.require(:post).permit(:text)
      end
  end
end