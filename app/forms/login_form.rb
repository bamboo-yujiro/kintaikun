class LoginForm
  include Virtus.model
  include ActiveModel::Model

  attr_accessor :password, :email

  def initialize
  end

  def login(params)
    self.email = params[:login_form][:email]
    u = User.where(email: email).first
    return false if u.nil? || u.password_digest.nil? # invalid hash 例外を防ぐ
    u && u.authenticate(params[:login_form][:password])
  end

end
