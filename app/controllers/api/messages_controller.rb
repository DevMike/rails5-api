module Api
  class MessagesController < ApiController

    # GET /messages
    api :GET, '/messages'
    def index
      @messages = current_api_user.messages

      render json: @messages
    end

    # POST /messages
    api :POST, '/messages'
    param :message, Hash, required: true, desc: 'Should contain `body` and `receiver_id`'
    def create
      @message = Message.new(message_params.merge(sender: current_api_user))

      if @message.save
        render json: @message, status: :created
      else
        render json: @message.errors, status: :unprocessable_entity
      end
    end

    private
      # Only allow a trusted parameter "white list" through.
      def message_params
        params.require(:message).permit(:receiver_id, :body)
      end
  end
end