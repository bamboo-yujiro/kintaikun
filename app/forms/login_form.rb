class LoginForm
  include ActiveModel::Model

  attr_reader :password, :email

  def initialize
  end

  def login(params)
    @email = params[:login_form][:email]
    user = User.where(email: email).first
    return false if user.nil? || user.password_digest.nil? # invalid hash 例外を防ぐ
    user.authenticate(params[:login_form][:password]) # authenticate は失敗したら false, 成功したら そのモデルのインスタンスを返す
  end

end
