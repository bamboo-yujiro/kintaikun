class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  before_action :set_user

  include Services::Session

  def set_user
    @current_user = current_user
  end


end
