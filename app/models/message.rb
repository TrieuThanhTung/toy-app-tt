# Message model
class Message < ApplicationRecord
  belongs_to :sender, class_name: "User"
  belongs_to :room

  has_one_attached :image
  has_one_attached :file

  validates :content, presence: true
  validates :image, content_type: {in: %w(image/jpeg image/jpg image/png image/gif), message: "must be a JPEG, JPG, or PNG."},
            size: {less_than: 5.megabytes, message: "must be less than 5MB"}
  validates :file, size: {less_than: 5.megabytes, message: "must be less than 5MB"}


  enum :message_type, {
    text: "text",
    image: "image",
    file: "file"
  }
end
