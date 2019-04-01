require 'rails_helper'

RSpec.describe "diseases/new", type: :view do
  before(:each) do
    assign(:disease, Disease.new(
      :name => "MyString",
      :symptons => "MyText"
    ))
  end

  it "renders new disease form" do
    render

    assert_select "form[action=?][method=?]", diseases_path, "post" do

      assert_select "input[name=?]", "disease[name]"

      assert_select "textarea[name=?]", "disease[symptons]"
    end
  end
end
