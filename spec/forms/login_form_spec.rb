require 'rails_helper'

describe LoginForm do

  describe '#login' do
    before do
      @user = User.create(name: 'Test', password: '12345678', password_confirmation: '12345678', email: 'hoge@hoge.com')
    end
    context 'email と password が正常の通常ログイン' do
      params = {login_form: {password: '12345678', email: 'hoge@hoge.com'}}
      subject { LoginForm.new.login(params) }
      it { is_expected.to eq @user }
    end

    context 'user が存在しない場合' do
      params = {login_form: {password: '12345678', email: 'Hogehoge@hoge.com'}}
      subject { LoginForm.new.login(params) }
      it { is_expected.to eq false }
    end

    context 'password が違う場合' do
      params = {login_form: {password: '1234567', email: 'hoge@hoge.com'}}
      subject { LoginForm.new.login(params) }
      it { is_expected.to eq false }
    end


  end

end
