FactoryBot.define do
  factory :comment do
    body { "Comment string" }

    trait :invalid do
      body { nil }
    end
  end
end