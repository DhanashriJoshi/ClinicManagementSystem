class Appointment < ApplicationRecord
  belongs_to :doctor
  belongs_to :patient
  belongs_to :disease
  has_one :treatment
end
