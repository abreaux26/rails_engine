FactoryBot.define do
  factory :invoice_item do
    quantity { Faker::Number.non_zero_digit }
    unit_price { Faker::Commerce.price }
    item
    invoice
  end
end
