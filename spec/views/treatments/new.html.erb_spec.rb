require 'rails_helper'

RSpec.describe "treatments/new", type: :view do
  before(:each) do
    assign(:treatment, Treatment.new(
      :appointment_id => 1
    ))
  end

  it "renders new treatment form" do
    render

    assert_select "form[action=?][method=?]", treatments_path, "post" do

      assert_select "input[name=?]", "treatment[appointment_id]"
    end
  end
end
