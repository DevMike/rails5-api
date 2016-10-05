module Api
  class UsersController < ApiController
    before_action :set_user, only: [:show, :update, :destroy]

    # GET /users
    api :GET, '/users'
    def index
      @users = User.all

      render json: @users
    end

    # GET /users/1
    api :GET, '/users/:id'
    def show
      render json: @user
    end

    # POST /users
    api :POST, '/users'
    param :user, Hash, required: true, desc: 'can contain `first_name`, `last_name`, `email`'
    def create
      @user = User.new(user_params)

      authorize @user, :create?

      if @user.save
        render json: @user, status: :created, location: @user
      else
        render json: @user.errors, status: :unprocessable_entity
      end
    end

    # PATCH/PUT /users/1
    api :PATCH, '/users/:id'
    param :id, :number, required: true
    param :user, Hash, required: true, desc: 'can contain `first_name`, `last_name`, `email`'
    def update
      authorize @user, :update?

      if @user.update(user_params)
        render json: @user.as_json.merge(update_auth_header)
      else
        render json: update_auth_header.merge(@user.errors), status: :unprocessable_entity
      end
    end

    # DELETE /users/1
    api :DELETE, '/users/:id'
    param :id, :number, required: true
    def destroy
      authorize @user, :destroy?

      @user.destroy
    end

    private

      # Use callbacks to share common setup or constraints between actions.
      def set_user
        @user = User.find(params[:id])
      end

      # Only allow a trusted parameter "white list" through.
      def user_params
        params.require(:user).permit(:first_name, :last_name, :email)
      end
  end
end