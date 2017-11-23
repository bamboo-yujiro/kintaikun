class User < ApplicationRecord
  validates :name, :password, :name, presence:  {message: 'は必須です。'}
  validates :email, uniqueness: {message: '重複'}
  has_secure_password
  validate :check_password

  def self.new_remember_token
    SecureRandom.urlsafe_base64
  end

  def self.encrypt(token)
    Digest::SHA1.hexdigest(token.to_s)
  end

  def check_password
    errors[:password].clear if defined?(errors[:password])
    errors[:password_confirmation].clear if defined?(errors[:password_confirmation])
    if password != password_confirmation
      errors.add(:password, "が一致してません")
    end
  end

end
