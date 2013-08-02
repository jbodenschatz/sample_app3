# == Schema Information
#
# Table name: users
#
#  id              :integer          not null, primary key
#  name            :string(255)
#  email           :string(255)
#  created_at      :datetime
#  updated_at      :datetime
#  password_digest :string(255)
#

class User < ActiveRecord::Base
  before_save { self.email = email.downcase }
  before_create :create_remember_token

  validates :name,  presence: true, length: { maximum: 50 }
  # validates(:name,  presence: true, length: { maximum: 50 })
  
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email, presence:   true,
                    format:     { with: VALID_EMAIL_REGEX },
                    uniqueness: {case_sensitive: false}
  # validates(:email, presence: true, format: { with: VALID_EMAIL_REGEX }, uniqueness: {case_sensitive: false})
  
  has_secure_password #Rails method introduced in 3.1
  validates :password, length: { minimum: 6 }
  
  def User.new_remember_token
    SecureRandom.urlsafe_base64
  end
  
  def User.encrypt(token)
    Digest::SHA1.hexdigest(token.to_s)
  end
  
  private
  
    def create_remember_token
      self.remember_token = User.encrypt(User.new_remember_token)
    end
end
