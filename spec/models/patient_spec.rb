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

  describe '#store_age' do
    context 'stores present age of Patient as of today' do
      it 'when valid patient is saved' do
        patient = Patient.last
        expect(patient.store_age).to be_truthy
      end
    end
  end

  describe '.patients_suffering_from_specific_disease' do
    context 'returns array of patients' do
      it 'when valid disease name is present' do
        expect(Patient.patients_suffering_from_specific_disease('Fatigue').count).to eq(2)
      end

      it 'when disease name is not present in the database' do
        expect(Patient.patients_suffering_from_specific_disease('fatigue')).to eq([])
      end

      it 'when disease name is not present' do
        expect(Disease.min_age_of_patient_suffering_from_specific_disease(nil)).to be_nil
      end
    end
  end

  describe '.patients_attented_for_timespan_for_disease' do
    context 'returns array of patients' do
      it 'when valid parameters passed' do
        start_date, end_date, disease_name = '25/03/2019'.to_date, '02/04/2019'.to_date, 'Diabetes'
        expect(Patient.patients_attented_for_timespan_for_disease(start_date, end_date, disease_name).count).to eq(1)
      end

      it 'when invalid dates passed' do
        start_date, end_date, disease_name = '', '02/04/2019'.to_date, 'diabetes'
        expect(Patient.patients_attented_for_timespan_for_disease(start_date, end_date, disease_name)).to be_nil
      end

      it 'when invalid disease name passed' do
        start_date, end_date, disease_name = '25/03/2019'.to_date, '02/04/2019'.to_date, 'diabetes'
        expect(Patient.patients_attented_for_timespan_for_disease(start_date, end_date, disease_name)).to eq([])
      end

      it 'when all parameters are invalid' do
        start_date, end_date, disease_name = nil, nil, nil
        expect(Patient.patients_attented_for_timespan_for_disease(start_date, end_date, disease_name)).to be_nil
      end
    end
  end

  describe '.treatment_for_disease' do
    context 'returns array of treatments' do
      patient = Patient.find_by_id(3)
      it 'when valid disease name is present' do
        expect(patient.treatment_for_disease('Cancer').count).to eq(1)
      end

      it 'when disease name is not present in the database' do
        expect(patient.treatment_for_disease('cancer')).to eq([])
      end

      it 'when disease name is not present' do
        expect(patient.treatment_for_disease(nil)).to be_nil
      end
    end
  end

  describe '.treatment_for_disease' do
    context 'returns array of patients history based on appointments' do
      it 'when history is present' do
        patient = Patient.find_by_id(3)
        response = patient.patients_history
        expect(response.count).to eq(2)
          expect(response).to be_kind_of(Array)
      end

      it 'when history is not present' do
        patient = Patient.find_by_id(2)
        response = patient.patients_history
        expect(response.count).to eq(0)
      end
    end
  end
end
