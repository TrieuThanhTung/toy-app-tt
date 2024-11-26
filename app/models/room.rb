class Room < ApplicationRecord
  has_many :participants, dependent: :destroy

  validates :title, presence: true

  enum :room_type, {
    private: "private",
    group: "group"
  }, prefix: true
end
