class User < ApplicationRecord
  has_many :articles
  validates :username, presence: true, length: { minimum: 3, maximum: 25 }, uniqueness: { case_sensitive: false }
  validates :email, presence: true, length: { maximum: 105 }, uniqueness: { case_sensitive: false }
  validates :password, presence: true, length: { minimum: 6, maximum: 25 }
end
