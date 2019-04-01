class ToCreateJoinTablePatientDisease < ActiveRecord::Migration[5.2]
  def up
    create_join_table :patients, :diseases, id: false do |t|
      t.index [:patient_id, :disease_id]
    end
  end

  def down
    drop_table :patients_diseases
  end
end
