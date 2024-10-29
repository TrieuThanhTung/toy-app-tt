class Provider < ApplicationRecord
  belongs_to :user
  validates :name, presence: true
  validates :uid, presence: true
end
