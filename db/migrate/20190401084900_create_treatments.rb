class CreateTreatments < ActiveRecord::Migration[5.2]
  def up
    create_table :treatments do |t|
      t.text    :description
      t.integer :appointment_id
      t.integer :disease_id

      t.timestamps
    end
  end

  def down
    drop_table :treatments
  end
end
