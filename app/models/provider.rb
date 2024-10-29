class Provider < ApplicationRecord
  belongs_to :user
  validates :provider_name, presence: true
  validates :uid, presence: true
end
