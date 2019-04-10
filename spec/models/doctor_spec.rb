require 'rails_helper'

RSpec.describe Doctor, type: :model do
  describe '.get_doctors_list_from_api_call' do
    context "with valid Request" do
      let(:uri) { 'https://demo6333249.mockable.io/get_list_of_doctors_name' }
      let(:body) { "{\n \"doctors\": {\n     \"names\": [\n         \"Dr. A\",\n         \"Dr. B\"\n         ]\n }\n}\n" }
      it "gets a JSON of Name of Doctors List" do
        stub_get = WebMock.stub_request(:get, uri).to_return(status: 200)
        stub_response = stub_get.response
        resp = Doctor.get_doctors_list_from_api_call
        expect(stub_response.status).to include(resp.code)
        expect(resp.body).to eq(stub_response.body)
      end
    end

    # context "when api is not working" do
    #   let(:uri) { 'https://demo6333249.mockable.io/get_list_of_doctors_name' }
    #   it "gets 404" do
    #     stub_get = WebMock.stub_request(:get, uri).to_return(status: 404)
    #     stub_response = stub_get.response
    #     resp = Doctor.get_doctors_list_from_api_call
    #     expect(stub_response.status).to include(resp.code)
    #   end
    # end
  end

  describe '.get_doctors_list_json' do
    context "returns json of list of doctor's names" do
      it 'stubs class method' do
        response = {"doctors" => {"names" => ["Dr. A", "Dr. B"]}}
        allow(Doctor).to receive(:get_doctors_list_json).and_return(response)
      end
    end
  end
end
