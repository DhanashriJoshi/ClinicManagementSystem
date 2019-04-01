class Disease < ApplicationRecord
  validates :name, :symptons, presence: true
  validates :name,  uniqueness: true
  has_and_belongs_to_many :patients
  has_many :appointments
  has_many :doctors, through: :appointments

  def self.import_diseases(file_path)
    error_report, success_flag, error_file = [], true, nil
    file = Roo::Spreadsheet.open(file_path)
    diseases_sheet = file.sheet(0)

    diseases_sheet.each_with_index do |row, index|
      tmp_arr = row
      tmp_arr << ''
      begin
        if index.zero? # row(0) consists of Headers
          tmp_arr << 'Please Find the errors below'
          error_report << tmp_arr
          next
        end

        error_messages = check_if_row_is_valid(row)
        unless error_messages.present?
          Disease.create!(to_diseases_obj(row))
        else
          tmp_arr << error_messages
          error_report << tmp_arr
          next
        end
      rescue Exception => e
        ap e.message
        ap e.backtrace
        tmp_arr << e.message
        error_report << tmp_arr
        next
      end
    end

    if error_report.present? && (error_report.length > 1)
      success_flag = false
      error_file = create_disease_error_report(error_report)
    end

    return success_flag, error_file
  end

  def self.to_diseases_obj(row)
    {
      name: row[0],
      symptons: row[1]
    }
  end

  def self.check_if_row_is_valid(row)
    error_messages = []

    if row[0].blank?
      error_messages << 'Disease Name is Mandatory'
    end

    if row[1].blank?
      error_messages << 'Disease Symptons are Mandatory'
    end

    msgs = error_messages.join(', ') if error_messages.present?
    msgs
  end

  def self.create_disease_error_report(errors_arr)
    book = Spreadsheet::Workbook.new
    error_sheet = book.create_worksheet name: 'Errors'
    errors_arr.each_with_index do |error_row, index|
      error_sheet.row(index).replace error_row
    end
    blob = StringIO.new('')
    book.write blob
    blob.string
  end

  def self.min_age_of_patient_suffering_from_specific_disease(disease_name='')
    if disease_name.present?
      disease = self.find_by_name(disease_name)
     # Disease.first.patients.having('min(age) >= 15').group(:birth_date).minimum(:age)
      disease.patients.minimum(:age)
    end
  end
end