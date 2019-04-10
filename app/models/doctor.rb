class Doctor < ApplicationRecord
  has_many :appointments
  has_many :patients, through: :appointments

  def self.get_doctors_list_from_api_call
    response = RestClient.get 'https://demo6333249.mockable.io/get_list_of_doctors_name'
    # JSON.parse response.body
  end

  def self.get_doctors_list_json
    response = RestClient.get 'https://demo6333249.mockable.io/get_list_of_doctors_name'
    JSON.parse response.body
  end
end
