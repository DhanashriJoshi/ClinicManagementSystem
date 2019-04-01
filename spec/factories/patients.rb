FactoryBot.define do
  factory :patient do
    name { Faker::Name.name }
    birth_date { Faker::Date.birthday(15, 65) }
    address { Faker::Address.street_address }
  end
end
