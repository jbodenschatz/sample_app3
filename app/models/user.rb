class User < ActiveRecord::Base
  before_save { self.email = email.downcase }

  validates :name,  presence: true, length: { maximum: 50 }
  # validates(:name,  presence: true, length: { maximum: 50 })
  
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email, presence:   true,
                    format:     { with: VALID_EMAIL_REGEX },
                    uniqueness: {case_sensitive: false}
  # validates(:email, presence: true, format: { with: VALID_EMAIL_REGEX }, uniqueness: {case_sensitive: false})
  
  has_secure_password #Rails method introduced in 3.1
  validates :password, length: { minimum: 6 }
end
