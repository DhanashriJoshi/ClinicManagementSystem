require 'rails_helper'

RSpec.describe "treatments/edit", type: :view do
  before(:each) do
    @treatment = assign(:treatment, Treatment.create!(
      :appointment_id => 1
    ))
  end

  it "renders the edit treatment form" do
    render

    assert_select "form[action=?][method=?]", treatment_path(@treatment), "post" do

      assert_select "input[name=?]", "treatment[appointment_id]"
    end
  end
end
