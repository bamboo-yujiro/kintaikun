module SessionsHelper#統合

  def log_in(user)
    remember_token = GeneralUser.new_remember_token
    session[:remember_token_general] = remember_token #ログイン後に認証するためのsession情報(cookie)
    user.update_attribute(:remember_token, GeneralUser.encrypt(remember_token)) #userテーブルのレコードを更新する(remember_token)
    self.current_user = user # setterメソッドを利用する
  end

  def log_out
    self.current_user = nil
    session.delete(:remember_token_general)
  end

  def current_user=(user) #setterメソッド. attr_writer :current_user と書くのと同じ
    @current_user =  user
  end

  def current_user
    remember_token = GeneralUser.encrypt(session[:remember_token_general])
    @current_user ||= GeneralUser.find_by(remember_token: remember_token) #@current_user = @current_user || ::Admin::AdminUser.find_by(remember_token: remember_token)
  end

  def current_user?(user)
    user == current_user
  end

  def loged_in?
    !current_user.nil?
  end

  def loged_in_user
    redirect_to login_url unless loged_in?
  end

end
