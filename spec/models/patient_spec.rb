require 'rails_helper'

RSpec.describe Patient, type: :model do
  context 'Validation Tests' do
    it { should validate_presence_of(:name) }
    it { should validate_presence_of(:birth_date) }
    it { should validate_length_of(:address).is_at_most(50) }
  end

  context 'create patient records' do
    it 'has valid attribute values' do
      patient = build(:patient)
      expect(patient).to be_valid
    end

    it 'has invalid attribute values' do
      invalid_patient = build(:patient, name: '')
      expect(invalid_patient).not_to be_valid
    end
  end
end
