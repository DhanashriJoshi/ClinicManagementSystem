require 'rails_helper'

RSpec.describe "doctors/show", type: :view do
  before(:each) do
    @doctor = assign(:doctor, Doctor.create!(
      :name => "Name"
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/Name/)
  end
end
