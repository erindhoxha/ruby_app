class Article < ApplicationRecord
  validates :description, presence: true, length: { minimum: 0, maximum: 300}
  # belongs_to :user
end
