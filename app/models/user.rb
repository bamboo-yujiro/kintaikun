class User < ApplicationRecord
  validates :name,
    presence:  {message: 'お名前は必須です。'},
    length: { in: 4..16, message: 'お名前は4文字以上、16文字以内で設定してください。' }
  validates :email,
    uniqueness: {message: 'ご指定のメールアドレスは既に登録されています。'},
    format: { with: /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i, message: 'Emailアドレスの形式がおかしいです。' }
  validates :password, length: { in: 8..16, message: 'パスワードは8文字以上、16文字以内で設定してください。' }

  has_secure_password

  def self.new_remember_token
    SecureRandom.urlsafe_base64
  end

  def self.encrypt(token)
    Digest::SHA1.hexdigest(token.to_s)
  end

end
