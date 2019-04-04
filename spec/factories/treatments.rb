FactoryBot.define do
  factory :treatment do
    description { 'This is a Treatment' }
    appointment_id { FactoryBot.create(:appointment).id }
  end
end
