class ApplicationController < ActionController::Base
  before_action :authenticate_user!
  before_action :configure_permitted_parameters, if: :devise_controller?
  before_action :set_chatroom

  def configure_permitted_parameters
    # For additional fields in app/views/devise/registrations/new.html.erb
    devise_parameter_sanitizer.permit(:sign_up, keys: [:username, :image])

    # For additional in app/views/devise/registrations/edit.html.erb
    devise_parameter_sanitizer.permit(:account_update, keys: [:username, :image])
  end

  def set_chatroom
    @chatroom = Chatroom.first # or any logic to find the appropriate chatroom
  end

  def default_url_options
    { host: ENV["DOMAIN"] || "localhost:3000" }
  end
end
