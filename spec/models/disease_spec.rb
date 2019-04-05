require 'rails_helper'

RSpec.describe Disease, type: :model do
  context 'create disease records' do
    it 'has valid attribute values' do
      disease = build(:disease)
      expect(disease).to be_valid
    end
  end

  describe '.import_diseases' do
    context 'returns array' do
      common_path = "#{Rails.root}/spec/factories"
      it 'when there is a valid xls file_path' do
        disease_file_path = "#{common_path}/Diseases_new.xlsx"
        resp_obj = [true, nil, '']
        expect(Disease.import_diseases(disease_file_path, '.xlsx')).to eq(resp_obj)
      end

      it 'when there is a invalid xls file_path' do
        disease_file_path = "#{common_path}/Diseases_invalid_data.xlsx"
        response = Disease.import_diseases(disease_file_path, '.xlsx')
        expect(response[0]).to be_falsy
        expect(response[1]).to be_kind_of(String)
        expect(response[2]).to eq('There are errors in the uploaded File')
      end

      it 'when there is a valid xls file_obj' do
        disease_file_path = "#{common_path}/Diseases_new1.xlsx"
        file = ActionDispatch::Http::UploadedFile.new(tempfile: disease_file_path, filename: File.basename(disease_file_path), type: "application/xlsx")
        resp_obj = [true, nil, '']
        expect(Disease.import_diseases(disease_file_path, '.xlsx')).to eq(resp_obj)
      end

      it 'when there is a invalid xls file obj' do
        disease_file_path = "#{common_path}/Diseases_invalid_data.xlsx"
        file = ActionDispatch::Http::UploadedFile.new(tempfile: disease_file_path, filename: File.basename(disease_file_path), type: "application/xlsx")
        response = Disease.import_diseases(file, '.xlsx')
        expect(response[0]).to be_falsy
        expect(response[1]).to be_kind_of(String)
        expect(response[2]).to eq('There are errors in the uploaded File')
      end

      it 'when there is a xls file with invalid file format' do
        disease_file_path = "#{common_path}/Diseases_blank_header.xlsx"
        response = Disease.import_diseases(disease_file_path, '.xlsx')
        expect(response[0]).to be_falsy
        expect(response[1]).to be_nil
        expect(response[2]).to eq('Invalid Format of Data in the uploaded file')
      end

      it 'when there is a wrong file with file_extention other than csv / xls / xlsx' do
        disease_file_path = "#{common_path}/wrong_file"
        response = Disease.import_diseases(disease_file_path)
        expect(response[0]).to be_falsy
        expect(response[1]).to be_nil
        expect(response[2]).to include 'Please Upload xls/ csv File Format'
      end

      it 'when there is a valid file_path of csv file' do
        disease_file_path = "#{common_path}/Diseases_Sheet1.csv"
        resp_obj = [true, nil, '']
        expect(Disease.import_diseases(disease_file_path, '.csv')).to eq(resp_obj)
      end
    end
  end

  describe '.check_if_row_is_valid' do
    context 'validate the row' do
      it 'when there is row' do
        row = ['Cancer', 'Unexpected weight loss, night sweats, or fever']
        expect(Disease.check_if_row_is_valid(row)).to be_nil
      end

      it 'when there is name blank' do
        row = ['', 'Unexpected weight loss, night sweats, or fever']
        expect(Disease.check_if_row_is_valid(row)).to eq('Disease Name is Mandatory')
      end

      it 'when there are symptoms blank' do
        row = ['Cancer', '']
        expect(Disease.check_if_row_is_valid(row)).to eq('Disease Symptons are Mandatory')
      end

      it 'when the name and symptoms are blank' do
        row = ['', '']
        expect(Disease.check_if_row_is_valid(row)).to include 'Disease Name is Mandatory, Disease Symptons are Mandatory'
      end
    end
  end

  describe '.to_diseases_obj' do
    context 'returns disease hash for valid row' do
      it 'when there is a valid row' do
        row = ['Cancer', 'Unexpected weight loss, night sweats, or fever']
        expect(Disease.to_diseases_obj(row)).to eq({name: 'Cancer', symptons: 'Unexpected weight loss, night sweats, or fever'})
      end
    end
  end

  describe '.min_age_of_patient_suffering_from_specific_disease' do
    context 'returns minimum age of patient suffering from specific diseases' do
      it 'when valid disease name is present' do
        disease = create(:disease)
        disease_name = disease.name
        patients_minimum_age = disease.patients.pluck(:age).min
        expect(Disease.min_age_of_patient_suffering_from_specific_disease(disease_name)).to eq(patients_minimum_age)
      end

      it 'when invalid disease name is present' do
        expect(Disease.min_age_of_patient_suffering_from_specific_disease('arfasas')).to be_nil
      end

      it 'when disease name is not present' do
        expect(Disease.min_age_of_patient_suffering_from_specific_disease('')).to be_nil
      end
    end
  end

  describe '.doctors_treating_patients_for_given_disease' do
    let(:appointments) { create_list(:appointment, 3, patient_id: FactoryBot.create(:patient).id, disease_id:  FactoryBot.create(:disease).id) }
    let(:disease_name) { appointments.first.disease.name }
    context 'returns array of doctors' do
      it 'when valid disease name is present' do
        response_count = Disease.find_by_name(disease_name).doctors.count
        expect(Disease.doctors_treating_patients_for_given_disease(disease_name).count).to eq(response_count)
      end

      it 'when disease name is not present in the database' do
        expect(Disease.doctors_treating_patients_for_given_disease('sgzsgsgsd')).to be_nil
      end

      it 'when disease name is not present' do
        expect(Disease.doctors_treating_patients_for_given_disease(nil)).to be_nil
      end
    end
  end

  describe '.frequently_treated_diseases' do
    context 'returns hash of Diseases paired with its frequency' do
      it 'when the method is called on class Disease' do
        # resp_hash = {"Cancer"=>3, "Diabetes"=>13, "Fatigue"=>2, "Fever"=>4}
        disease = FactoryBot.create(:disease)
        disease_id = disease.id
        create(:appointment)
        create(:appointment, disease_id: disease_id)
        create(:appointment, disease_id: disease_id)
        response = Disease.frequently_treated_diseases
        expect(response).to be_kind_of(Hash)
        expect(response).to have_key(disease.name)
        response.each do |key, value|
          expect(value).not_to be_zero
        end
      end
    end
  end


  context 'validation tests' do
    it { should validate_presence_of(:name) }
    it { should validate_presence_of(:symptons) }
    it { should validate_uniqueness_of(:name) }
  end
end
