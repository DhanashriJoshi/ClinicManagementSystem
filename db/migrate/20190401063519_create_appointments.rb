class CreateAppointments < ActiveRecord::Migration[5.2]
  def change
    create_table :appointments do |t|
      t.date :date
      t.time :time
      t.integer :patient_id
      t.integer :doctor_id
      t.integer :disease_id

      t.timestamps
    end
  end
end
