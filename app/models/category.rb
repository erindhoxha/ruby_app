class Category < ApplicationRecord
 validates :name, presence: true, length: { minimum: 3, maximum: 50 }
 validates_uniqueness_of :name
 has_many :article_categories
 has_many :article, through: :article_categories
end