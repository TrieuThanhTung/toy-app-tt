# Micropost model
class Micropost < ApplicationRecord
  belongs_to :user
  belongs_to :parent, class_name: "Micropost", optional: true
  has_many :comments, class_name: "Micropost", foreign_key: "parent_id", dependent: :destroy
  has_many :reactions
  has_one_attached :image
  default_scope -> { order(created_at: :desc) }

  validates :content, presence: true
  validates :image, content_type: { in: %w[image/jpeg image/gif image/png], message: "must be a valid image format" },
                            size: { less_than: 100.kilobytes, message: "should be less than 100KB" }

  def display_image
    image.variant(resize_to_limit: [ 500, 500 ])
  end
end
