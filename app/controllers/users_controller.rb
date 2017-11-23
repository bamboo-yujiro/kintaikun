class UsersController < ApplicationController

  def new
    @user = User.new
  end

  def create
    @user = User.new(params.require(:user).permit(:name, :email, :password, :password_confirmation))
    if @user.save
      redirect_to '/', :notice => "ユーザー作成しました"
    else
      render action: 'new'
    end
  end

  def login
    @login_form = LoginForm.new
  end

  def login_post
    @login_form = LoginForm.new
    if @login_form.login(params)
      flash.now[:notice] =  'ログインしました。'
      redirect_to '/'
      return
    end
    flash.now[:alert] =  'Emailかパスワードが間違っています。'
    render action: 'login'
  end

end
