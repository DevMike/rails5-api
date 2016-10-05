module Api
  class CommentsController < ApiController
    # POST /comments
    api :POST, 'posts/:post_id/comments'
    param :post_id, :number, required: true
    param :comment, Hash, required: true, desc: 'Should contain `text` string'
    def create
      @comment = Comment.new(comment_params.merge(user: current_api_user, post_id: params[:post_id]))

      if @comment.save
        render json: @comment, status: :created
      else
        render json: @comment.errors, status: :unprocessable_entity
      end
    end

    private
      # Only allow a trusted parameter "white list" through.
      def comment_params
        params.require(:comment).permit(:text)
      end
  end
end