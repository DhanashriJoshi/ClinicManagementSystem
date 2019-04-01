FactoryBot.define do
  factory :appointment do
    date { "2019-04-01" }
    time { "2019-04-01 12:05:19" }
    patient_id { 1 }
    doctor_id { 1 }
    disease_id { 1 }
  end
end
