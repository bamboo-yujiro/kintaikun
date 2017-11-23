class LoginForm
  include ActiveModel::Model

  attr_accessor :user, :password, :email

  def initialize
  end

  def login(params)
    self.email = params[:login_form][:email]
    self.user = User.where(email: email).first
    return false if self.user.nil? || self.user.password_digest.nil? # invalid hash 例外を防ぐ
    self.user.authenticate(params[:login_form][:password])
  end

end
