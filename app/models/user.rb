class User < ApplicationRecord
  has_many :microposts
  before_save { self.email = email.downcase }
  validates :name, presence: true, length: { in: 6..255 }
  validates :email, presence: true,
    format: { with: /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i },
    uniqueness: { case_sensitive: true }
  has_secure_password
  validates :password, length: { minimum: 6 }
end
