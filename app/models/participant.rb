class Participant < ApplicationRecord
  belongs_to :user
  belongs_to :room

  enum :role, {
    admin: "admin",
    member: "member"
  }, prefix: true
end
