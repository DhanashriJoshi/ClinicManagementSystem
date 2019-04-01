require 'rails_helper'

RSpec.describe Disease, type: :model do
  context 'create disease records' do
    it 'has valid attribute values' do
      disease = build(:disease)
      expect(disease).to be_valid
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
        expect(Disease.check_if_row_is_valid(row)).to eq('Disease Name is Mandatory, Disease Symptons are Mandatory')
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

  context 'validation tests' do
    it { should validate_presence_of(:name) }
    it { should validate_presence_of(:symptons) }
    it { should validate_uniqueness_of(:name) }
  end
end
