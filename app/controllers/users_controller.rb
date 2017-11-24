class UsersController < ApplicationController

  def new
    @user = User.new
  end

  def create
    @user = User.new(params.require(:user).permit(:name, :email, :password, :password_confirmation))
    if @user.save
      redirect_to '/', notice: 'ユーザーを作成しました'
    else
      flash.now[:alert] = 'ユーザーの作成に失敗しました。'
      render action: 'new'
    end
  end

  def login
    @login_form = LoginForm.new
  end

  def login_post
    @login_form = LoginForm.new
    if !@login_form.login(params)
      flash.now[:alert] =  'Emailかパスワードが間違っています。'
      render action: 'login'
      return
    end
    log_in(@login_form.user)
    flash.now[:notice] =  'ログインしました。'
    redirect_to '/'
  end

  def logout
    log_out
    redirect_to ''
  end

end
