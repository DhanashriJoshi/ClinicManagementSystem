FactoryBot.define do
  factory :appointment do
    date { Faker::Date.between(2.years.ago, Date.today) }
    time { Faker::Time.between(DateTime.now - 7.hours, DateTime.now + 2.hours) }
    duration { rand(1..60) }
    fees { rand(300..500) }
    patient_id { FactoryBot.create(:patient).id }
    doctor_id { FactoryBot.create(:doctor).id }
    disease_id { FactoryBot.create(:disease).id }
  end

  factory :appointment_with_treatments do
    date { Faker::Date.between(2.years.ago, Date.today) }
    time { Faker::Time.between(DateTime.now - 7.hours, DateTime.now + 2.hours) }
    duration { rand(1..60) }
    fees { rand(300..500) }
    patient_id { FactoryBot.create(:patient).id }
    doctor_id { FactoryBot.create(:doctor).id }
    disease_id { FactoryBot.create(:disease).id }
    treatments { FactoryBot.create_list(:treatment, 2) }
  end
end
