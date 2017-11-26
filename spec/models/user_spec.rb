require 'rails_helper'

describe User, type: :model do

  describe 'Validation' do

    context "名前が未記入" do
      user = User.new(name: '')
      user.valid?
      example 'NG' do
        expect(user.errors[:name]).to include('お名前は必須です。')
      end
    end

    context '名前が3文字' do
      user = User.new(name: '')
      user.valid?
      example 'NG' do
        expect(user.errors[:name]).to include('お名前は4文字以上、16文字以内で設定してください。')
      end
    end

    context 'メールアドレスが重複' do
      User.create(name: 'Test', password: '12345678', password_confirmation: '12345678', email: 'hoge@hoge.com')
      user = User.new(email: 'hoge@hoge.com')
      user.valid?
      it { expect(user.errors[:email]).to include('ご指定のメールアドレスは既に登録されています。') }
    end

    context 'メールアドレスが不正' do
      user = User.new(email: 'hogehoge@')
      user.valid?
      it { expect(user.errors[:email]).to include('Emailアドレスの形式がおかしいです。') }
    end

    context 'パスワードが7文字' do
      user = User.new(password: '1234567')
      user.valid?
      it { expect(user.errors[:password]).to include('パスワードは8文字以上、16文字以内で設定してください。') }
    end

    context 'パスワードが一致してない' do
      user = User.new(password: '12345678', password_confirmation: '12345679')
      user.valid?
      it { expect(user.errors[:password_confirmation]).to include('パスワードが確認用のものと一致してません。') }
    end

  end

end
