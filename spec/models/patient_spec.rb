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


  let(:patient) { create(:patient) }
  let(:disease_name){ patient.diseases.first.name }

  describe '#store_age' do
    context 'stores present age of Patient as of today' do
      it 'when valid patient is saved' do
        # patient = create(:patient)
        expect(patient.store_age).to be_truthy
      end
    end
  end

  describe '.patients_suffering_from_specific_disease' do
    # let(:patient) { create(:patient) }
    # let(:disease_name){ patient.diseases.first.name }

    context 'returns array of patients' do
      it 'when valid disease name is present' do
        expected_resp = patient.diseases.where(name: disease_name)
        expect(Patient.patients_suffering_from_specific_disease(disease_name).count).to eq(expected_resp.count)
      end

      it 'when disease name is not present in the database' do
        expected_resp = patient.diseases.where(name: 'dfghjk').count
        expect(Patient.patients_suffering_from_specific_disease('dfghjk').count).to eq(expected_resp)
      end

      it 'when disease name is not present' do
        expect(Disease.min_age_of_patient_suffering_from_specific_disease(nil)).to be_nil
      end
    end
  end

  describe '.patients_attented_for_timespan_for_disease' do
    let(:appointments) { create_list(:appointment, 3, patient_id: FactoryBot.create(:patient).id, doctor_id: FactoryBot.create(:doctor).id, disease_id:  FactoryBot.create(:disease).id) }
    let(:disease_name) { appointments.first.disease.name }
    let(:sorted_dates) { appointments.pluck(:date).sort }
    let(:start_date) { sorted_dates.first }
    let(:end_date) { sorted_dates.last }

    context 'returns array of patients' do
      it 'when valid parameters passed' do
        response = Patient.patients_attented_for_timespan_for_disease(start_date, end_date, disease_name)
        expect(response).to be_an_instance_of(Array)
        expect(response.empty?).to be_falsy
        # expect(response.count).to eq(1)
      end

      it 'when invalid dates passed' do
        start_date = ''
        expect(Patient.patients_attented_for_timespan_for_disease(start_date, end_date, disease_name)).to be_nil
      end

      it 'when invalid disease name passed' do
        disease_name = 'gzgdhdhtdyhtd'
        expect(Patient.patients_attented_for_timespan_for_disease(start_date, end_date, disease_name)).to eq([])
      end

      it 'when all parameters are invalid' do
        start_date, end_date, disease_name = nil, nil, nil
        expect(Patient.patients_attented_for_timespan_for_disease(start_date, end_date, disease_name)).to be_nil
      end
    end
  end

  describe '.treatment_for_disease' do
    let(:appointment) { FactoryBot.create(:appointment) }
    let(:treatments) { FactoryBot.create(:treatment, appointment_id: appointment.id, disease_id: appointment.disease_id ) }
    let(:patient) { treatments.appointment.patient }
    let(:disease_name) { treatments.appointment.disease.name }

    context 'returns array of treatments' do
      it 'when valid disease name is present' do
        response = patient.treatment_for_disease(disease_name)
        expect(response).to be_an_instance_of(Array)
        expect(response.empty?).to be_falsy
        # expect(response.count).to eq(1)
      end

      it 'when disease name is not present in the database' do
        expect(patient.treatment_for_disease('sgtsgds')).to eq([])
      end

      it 'when disease name is not present' do
        expect(patient.treatment_for_disease(nil)).to be_nil
      end
    end
  end

  describe '.patients_history' do
    let(:appointment) { FactoryBot.create(:appointment) }
    let(:treatments) { FactoryBot.create(:treatment, appointment_id: appointment.id, disease_id: appointment.disease_id ) }
    let(:patient) { treatments.appointment.patient }
    let(:disease_name) { treatments.appointment.disease.name }

    context 'returns array of patients history based on appointments' do
      it 'when history is present' do
        response = patient.patients_history
        # expect(response.count).to eq(1)
        expect(response).to be_kind_of(Array)
        expect(response.empty?).to be_falsy
      end

      it 'when history is not present' do
        patient = create(:patient)
        response = patient.patients_history
        expect(response.count).to eq(0)
      end
    end
  end
end
