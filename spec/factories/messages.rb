FactoryBot.define do
  factory :message do
    sender { create(:user) }
    room { create(:room) }
    content { "MyText" }
  end
end
