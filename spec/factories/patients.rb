FactoryBot.define do
  factory :patient do
    name { Faker::Name.name }
    birth_date { Faker::Date.birthday(15, 65) }
    address { Faker::Address.street_address }
    diseases {FactoryBot.create_list(:disease, 2)}
  end

  # factory :patient_with_diseases do
  #   name { Faker::Name.name }
  #   birth_date { Faker::Date.birthday(15, 65) }
  #   address { Faker::Address.street_address }
  #   diseases {FactoryBot.create_list(:disease, 2)}
  # end
  #
  # factory :patient_with_appointments do
  #   name { Faker::Name.name }
  #   birth_date { Faker::Date.birthday(15, 65) }
  #   address { Faker::Address.street_address }
  #   diseases {FactoryBot.create_list(:disease, 2)}
  #   appointments {FactoryGirl.create_list(:appointment, 5)}
  # end
end

# FactoryGirl.define do
#
#   factory :company do
#     #company attributes
#   end
#
#   factory :user do
#    companies {[FactoryGirl.create(:company)]}
#    #user attributes
#   end
#
# end
