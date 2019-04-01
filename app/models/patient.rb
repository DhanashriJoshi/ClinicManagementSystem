class Patient < ApplicationRecord
  validates :name, :birth_date, presence: true
  validates_length_of :address, maximum: 50
  # validate :validate_age
  has_and_belongs_to_many :diseases
  has_many :appointments
  has_many :doctors, through: :appointments

  after_create :store_age
  after_update :store_age

  default_scope { order(birth_date: :asc) }

  def self.patients_suffering_from_specific_disease(disease_name="")
    self.joins(:diseases).where("diseases.name LIKE ?", "%#{disease_name}%") if disease_name.present?
  end

  def store_age
    self.update_column(:age, patient_age)
  end

  def patient_age
    (Time.zone.now.year - birth_date.year)
  end

  # private

  # def validate_age
  #   if birth_date.present? && birth_date > 18.years.ago.to_d
  #     errors.add(:birth_date, 'You should be over 18 years old.')
  #   end
  # end
end
