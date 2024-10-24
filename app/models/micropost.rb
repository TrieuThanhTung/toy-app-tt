class Micropost < ApplicationRecord
  belongs_to :user
  has_many :comment
  has_one_attached :image
  default_scope -> { order(created_at: :desc) }

  validates :title, presence: true, length: { in: 2..255, message: "Title's length is between 6 -> 255" }
  validates :content, presence: true, length: { in: 10...140, message: "Content's length between 10 -> 140 characters" }
  # validates :user_id, presence: true, numericality: { only_integer: true }
end
