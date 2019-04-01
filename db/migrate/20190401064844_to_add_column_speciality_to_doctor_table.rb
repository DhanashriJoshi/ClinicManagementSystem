class ToAddColumnSpecialityToDoctorTable < ActiveRecord::Migration[5.2]
  def up
    add_column :doctors, :speciality, :string
  end

  def down
    remove_column :doctors, :speciality
  end
end
