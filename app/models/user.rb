class User < ApplicationRecord
  validates :name, presence:  {message: '名前は必須です。'}
  validates :email,
    uniqueness: {message: 'ご指定のメールアドレスは既に登録されています。'},
    format: { with: /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i, message: 'Emailアドレスの形式がおかしいです。' }
  has_secure_password

  def self.new_remember_token
    SecureRandom.urlsafe_base64
  end

  def self.encrypt(token)
    Digest::SHA1.hexdigest(token.to_s)
  end

end
