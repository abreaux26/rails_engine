FactoryBot.define do
  factory :merchant do
    name { Faker::Commerce.department }
  end
end
