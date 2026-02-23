class Tag < ApplicationRecord
  class Tag < ApplicationRecord
  # A tag can be on many ingredients, but it has to go through the join table first.
  # dependent: :destroy ensures that if a tag is deleted, the "bridge" records are also cleaned up.
  has_many :ingredient_tags, dependent: :destroy
  has_many :ingredients, through: :ingredient_tags
  
  validates :name, presence: true, uniqueness: true
end
end
