FactoryBot.define do
  factory :badge do
    name { "MyString" }
  end

  trait :with_image do
    image { Rack::Test::UploadedFile.new("#{Rails.root}/spec/rails_helper.rb") }
  end
end
