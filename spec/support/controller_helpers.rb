module ControllerHelpers
  def sign_in(user)
    if user.nil?
      allow(request.env['warden']).to receive(:authenticate!).and_throw(:warden, {:scope => :user})
      allow(controller).to receive(:current_api_user).and_return(nil)
    else
      allow(request.env['warden']).to receive(:authenticate!).and_return(user)
      allow(controller).to receive(:current_api_user).and_return(user)
    end
  end

  def auth_request(user)
    sign_in user
    request.headers.merge!(user.create_new_auth_token)
  end
end