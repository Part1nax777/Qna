FactoryBot.define do
  factory :comment do
    body { "Comment string" }

    trait :invalid do
      body { nil }
    end
  end

  factory :question_comment, class: Comment do
    association :commentable, factory: :question
    body { "Comment text" }
  end
end