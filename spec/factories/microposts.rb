FactoryBot.define do
  factory :micropost do
    content { Faker::Lorem.sentence }
    user_id { User.first.id }
  end
end
