require 'rails_helper'

RSpec.describe "treatments/show", type: :view do
  before(:each) do
    @treatment = assign(:treatment, Treatment.create!(
      :appointment_id => 2
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/2/)
  end
end
