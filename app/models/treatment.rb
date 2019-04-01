class Treatment < ApplicationRecord
  belongs_to :appointment
  belongs_to :disease, class_name: 'Disease'
end
