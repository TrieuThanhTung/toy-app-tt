class Reaction < ApplicationRecord
  belongs_to :user
  belongs_to :micropost
  validates :reaction_type, presence: true

  enum :reaction_type, {
    love: "love",
    sad: "sad",
    angry: "angry"
  }, prefix: true
end
