module Api
  class ApiController < ApplicationController
    include DeviseTokenAuth::Concerns::SetUserByToken

    rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized

    # Add a before_action to authenticate all requests.
    # Move this to subclassed controllers if you only
    # want to authenticate certain methods.
    before_action :authenticate_api_user!

    protected

    # required for pundit
    def current_user
      current_api_user
    end

    def user_not_authorized
      render status: 401
    end
  end
end
