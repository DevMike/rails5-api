module Api
  class FriendshipsController < ApiController
    before_action :set_friendship, only: [:show, :update, :destroy]

    # GET /friendships
    api :GET, '/friendships'
    def index
      @friendships = current_api_user.all_friends

      render json: @friendships
    end

    # POST /friendships
    api :POST, '/friendships'
    param :friendship, Hash, required: true, desc: "Should contain `friend_id` and optionally `state` if it's `blocked`"
    def create
      @friendship = Friendship.where('(user_id = :current_user AND friend_id = :friend) OR (user_id = :friend AND friend_id = :current_user)',
                                     current_user: current_api_user.id,
                                     friend: params[:friendship][:friend_id]).first

      if @friendship.try(:blocked?)
        render status: :forbidden and return
      elsif @friendship
        @friendship.state = params[:friendship][:state]
      else
        @friendship = Friendship.new(friendship_params.merge(user: current_api_user))
      end

      if @friendship.save
        render json: @friendship, status: :created
      else
        render json: @friendship.errors, status: :unprocessable_entity
      end
    end

    # DELETE /messages/1
    api :DELETE, '/friendships/:id'
    param :id, :number, required: true
    def destroy
      if @friendship.destroy
        render body: nil, status: :no_content
      else
        render status: :unprocessable_entity
      end
    end

    private
      # Use callbacks to share common setup or constraints between actions.
      def set_friendship
        @friendship = current_api_user.friendships.find(params[:id])
      end

      # Only allow a trusted parameter "white list" through.
      def friendship_params
        params.require(:friendship).permit(:friend_id, :state)
      end
  end
end