require 'rails_helper'

RSpec.describe "doctors/index", type: :view do
  before(:each) do
    assign(:doctors, [
      Doctor.create!(
        :name => "Name"
      ),
      Doctor.create!(
        :name => "Name"
      )
    ])
  end

  it "renders a list of doctors" do
    render
    assert_select "tr>td", :text => "Name".to_s, :count => 2
  end
end
