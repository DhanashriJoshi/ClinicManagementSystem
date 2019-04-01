FactoryBot.define do
  factory :doctor do
    name { Faker::Name.name }
    speciality { 'Cancer' }
  end
end
