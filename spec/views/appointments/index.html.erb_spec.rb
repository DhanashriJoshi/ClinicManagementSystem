require 'rails_helper'

RSpec.describe "appointments/index", type: :view do
  before(:each) do
    assign(:appointments, [
      Appointment.create!(
        :patient_id => 2,
        :doctor_id => 3,
        :disease_id => 4
      ),
      Appointment.create!(
        :patient_id => 2,
        :doctor_id => 3,
        :disease_id => 4
      )
    ])
  end

  it "renders a list of appointments" do
    render
    assert_select "tr>td", :text => 2.to_s, :count => 2
    assert_select "tr>td", :text => 3.to_s, :count => 2
    assert_select "tr>td", :text => 4.to_s, :count => 2
  end
end
