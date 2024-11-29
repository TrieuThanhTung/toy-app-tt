# Message model
class Message < ApplicationRecord
  belongs_to :sender, class_name: "User"
  belongs_to :room

  validates :content, presence: true

  enum :message_type, {
    text: "text",
    image: "image"
  }
end
