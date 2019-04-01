require 'rails_helper'

RSpec.describe "diseases/index", type: :view do
  before(:each) do
    assign(:diseases, [
      Disease.create!(
        :name => "Name",
        :symptons => "MyText"
      ),
      Disease.create!(
        :name => "Name",
        :symptons => "MyText"
      )
    ])
  end

  it "renders a list of diseases" do
    render
    assert_select "tr>td", :text => "Name".to_s, :count => 2
    assert_select "tr>td", :text => "MyText".to_s, :count => 2
  end
end
