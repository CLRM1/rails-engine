FactoryBot.define do
  factory :item do
    name { Faker::Appliance.brand }
    description { Faker::Lorem.sentence }
    unit_price { Faker::Number.decimal(l_digits: 2) }
    merchant { Faker::Company.name }
  end
end
