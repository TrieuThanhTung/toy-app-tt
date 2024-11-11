FactoryBot.define do
  factory :message do
    sender { nil }
    recipient { nil }
    content { "MyText" }
  end
end
