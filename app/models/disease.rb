class Disease < ApplicationRecord
  validates :name, :symptons, presence: true
  validates :name,  uniqueness: true
  has_and_belongs_to_many :patients
  has_many :appointments
  has_many :doctors, through: :appointments
  has_many :diseases
  has_many :treatments

  def self.min_age_of_patient_suffering_from_specific_disease(disease_name='')
    if disease_name.present?
      disease = self.find_by_name(disease_name)
      disease.patients.minimum(:age) if disease.present?
    end
  end

  def self.doctors_treating_patients_for_given_disease(disease_name="")
    if disease_name.present?
      disease = self.find_by_name(disease_name)
      disease.doctors.select('doctors.name as doctor_name, speciality as speciality').as_json.uniq if disease.present?
    end
  end

  def self.frequently_treated_diseases
    Disease.joins(:appointments).group('diseases.name').order('count(appointments.id) desc').references(:appointments).count
  end

  def self.import_diseases(file, file_extention=nil)
    error_report, success_flag, error_file, notification_message = [], true, nil, ''
    diseases_sheet = open_spreadsheet(file, file_extention)
    if ((diseases_sheet.is_a?String) && (diseases_sheet.include?'Unknown file type'))
      success_flag, error_file, notification_message = false, nil, diseases_sheet
      return success_flag, error_file, notification_message
    else
      diseases_sheet.each_with_index do |row, index|
        row.compact.present?
        tmp_arr = row
        tmp_arr << ''
        begin
          expected_headers = Disease.diseases_import_file_headers
          if  index.zero?
            if ((expected_headers & row) == expected_headers) # 0th row consists of Headers
              tmp_arr << 'Please Find the errors below'
              error_report << tmp_arr
              next
            else
              success_flag, error_file, notification_message = false, nil, 'Invalid Format of Data in the uploaded file'
              return success_flag, error_file, notification_message
            end
          end

          error_messages = check_if_row_is_valid(row)
          if error_messages.present?
            tmp_arr << error_messages
            error_report << tmp_arr
            next
          else
            Disease.create!(to_diseases_obj(row))
          end
        rescue Exception => e
          tmp_arr << e.message
          error_report << tmp_arr
          next
        end
      end

      if error_report.present? && (error_report.length > 1)
        success_flag = false
        notification_message = 'There are errors in the uploaded File'
        error_file = create_disease_error_report(error_report)
      end
      return success_flag, error_file, notification_message
    end
  end

  def self.open_spreadsheet(file, file_extention=nil)
    if (file.is_a?String)
      file_path = file
      file_name = file.split('/')[-1]
    else
      file_path = file.path
      file_name = file.original_filename
    end

    file_extention ||= (File.extname(file.original_filename) rescue '')

    case file_extention
    when '.csv'
      Roo::CSV.new(file_path)
    when '.xls', '.xlsx'
      spreadsheet = Roo::Spreadsheet.open(file_path)
      spreadsheet.sheet(0)
    else
      "Unknown file type: #{file_name}, Please Upload xls/ csv File Format"
    end
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

  def self.diseases_import_file_headers
    ['Name', 'Symptons']
  end
end
