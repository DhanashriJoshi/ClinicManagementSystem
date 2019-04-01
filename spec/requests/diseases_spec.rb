require 'rails_helper'

RSpec.describe "Diseases", type: :request do
  describe "GET /diseases" do
    it "works! (now write some real specs)" do
      get diseases_path
      expect(response).to have_http_status(200)
    end
  end
end
