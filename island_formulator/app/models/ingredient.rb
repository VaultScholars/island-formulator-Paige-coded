class Ingredient < ApplicationRecord
  belongs_to :user
  has_many :ingredient_tags, dependent: :destroy
  has_many :tags, through: :ingredient_tags
  
  validates :name, presence: true
  validates :category, presence: true
  validates :user, presence: true  # Ensures no orphaned ingredients
end
