require 'rails_helper'

RSpec.describe "diseases/edit", type: :view do
  before(:each) do
    @disease = assign(:disease, Disease.create!(
      :name => "MyString",
      :symptons => "MyText"
    ))
  end

  it "renders the edit disease form" do
    render

    assert_select "form[action=?][method=?]", disease_path(@disease), "post" do

      assert_select "input[name=?]", "disease[name]"

      assert_select "textarea[name=?]", "disease[symptons]"
    end
  end
end
