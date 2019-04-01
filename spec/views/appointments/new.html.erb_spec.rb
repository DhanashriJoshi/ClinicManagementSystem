require 'rails_helper'

RSpec.describe "appointments/new", type: :view do
  before(:each) do
    assign(:appointment, Appointment.new(
      :patient_id => 1,
      :doctor_id => 1,
      :disease_id => 1
    ))
  end

  it "renders new appointment form" do
    render

    assert_select "form[action=?][method=?]", appointments_path, "post" do

      assert_select "input[name=?]", "appointment[patient_id]"

      assert_select "input[name=?]", "appointment[doctor_id]"

      assert_select "input[name=?]", "appointment[disease_id]"
    end
  end
end
