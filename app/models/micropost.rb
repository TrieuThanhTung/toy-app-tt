class Micropost < ApplicationRecord
  belongs_to :user
  has_many :comment

  validates :title, presence: true, length: { in: 6..255, message: "Title's length is between 6 -> 255" }
  validates :content, presence: true, length: { minimum: 10 }
  validates :user_id, presence: true, numericality: { only_integer: true }
end
