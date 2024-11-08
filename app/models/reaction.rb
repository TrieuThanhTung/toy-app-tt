class Reaction < ApplicationRecord
  belongs_to :user
  belongs_to :micropost

  enum :reaction_type, {
    love: "love",
    sad: "sad",
    angry: "angry"
  }, prefix: true
end
