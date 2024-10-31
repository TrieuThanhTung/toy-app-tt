FactoryBot.define do
  factory :user do
    name { Faker::Name.name }
    age { Faker::Number.between(from: 20, to: 30) }
    email { Faker::Internet.email }
    password { "password" }
    password_confirmation { "password" }
  end
end
