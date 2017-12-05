module LoginMacros

  def login(user)
    visit login_users_path
    first('#login_form_email').set(user.email)
    first('#login_form_password').set(user.password)
    first('button[type="submit"]').click
  end

end
