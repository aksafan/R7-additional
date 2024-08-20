FactoryBot.define do
  factory :order do
    product_name { Faker::Book.title }
    product_count { Faker::Number.non_zero_digit }
    association :customer
  end
end
