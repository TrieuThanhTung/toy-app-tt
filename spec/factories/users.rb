FactoryBot.define do
  factory :user do
    name { Faker::Name.name }
    age { Faker::Number.between(from: 20, to: 30) }
    email { Faker::Internet.email }
    password { "password" }
    password_confirmation { "password" }
    activated { true }
    activated_at { Time.zone.now }
  end
end
