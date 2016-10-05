class ApplicationController < ActionController::API
  include DeviseTokenAuth::Concerns::SetUserByToken
  include Pundit

  rescue_from ActiveRecord::RecordNotFound do |exception|
    render body: nil, status: 404 # nothing, redirect or a template
  end
end
