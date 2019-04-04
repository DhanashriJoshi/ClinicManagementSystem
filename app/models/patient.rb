class Patient < ApplicationRecord
  validates :name, :birth_date, presence: true
  validate :birth_date_should_be_in_past, on: :create
  validates_length_of :address, maximum: 50
  has_and_belongs_to_many :diseases
  has_many :appointments
  has_many :doctors, through: :appointments
  has_many :treatments, through: :appointments

  after_create :store_age
  after_update :store_age


  default_scope { order(birth_date: :asc) }

  def self.patients_suffering_from_specific_disease(disease_name="")
    self.joins(:diseases).where(diseases: {name: disease_name}) if disease_name.present?
  end

  def store_age
    self.update_column(:age, patient_age)
  end

  def patient_age
    (Time.zone.now.year - birth_date.year)
  end

  def birth_date_should_be_in_past
    errors.add(:birth_date, "can't be in the future") if (self.birth_date.present? && self.birth_date.future?)
  end

  # Patients attended for the given timespan / for specific disease
  def self.patients_attented_for_timespan_for_disease(start_date, end_date, disease_name)
    flag = ((start_date.is_a?Date) && (end_date.is_a?Date))
    Patient.joins(appointments: :disease).where(appointments: {date: start_date..end_date}).where(diseases: {name: disease_name}).uniq if flag
  end

  # Treatment given to a specific patient for a specific disease
  def treatment_for_disease(disease_name='')
    if disease_name.present?
      self.treatments.joins(:disease).where(diseases: {name: disease_name})
    end
  end

  def patients_history
    patient = self
    Patient.where(id: patient.try(:id)).joins(appointments: [:treatment, :disease, :doctor]).select('patients.name as patient_name, treatments.description, diseases.name, doctors.name, appointments.date, appointments.time').as_json
  end
end
