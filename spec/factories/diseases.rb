FactoryBot.define do
  factory :disease do
    name { Faker::Name.name }
    symptons { Faker::Name.name }
  end
end
