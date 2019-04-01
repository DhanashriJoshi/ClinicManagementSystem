class ToAddColumnFeesAndDurationTimeToAppointmentTable < ActiveRecord::Migration[5.2]
  def up
    add_column :appointments, :duration, :integer
    add_column :appointments, :fees, :decimal
  end
end
