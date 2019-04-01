require 'rails_helper'

RSpec.describe "treatments/index", type: :view do
  before(:each) do
    assign(:treatments, [
      Treatment.create!(
        :appointment_id => 2
      ),
      Treatment.create!(
        :appointment_id => 2
      )
    ])
  end

  it "renders a list of treatments" do
    render
    assert_select "tr>td", :text => 2.to_s, :count => 2
  end
end
