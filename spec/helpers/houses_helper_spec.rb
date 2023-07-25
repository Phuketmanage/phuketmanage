require 'rails_helper'

RSpec.describe HousesHelper, type: :helper do
  let(:address) { "My house address" }
  let(:google_map) { "http://google.map" }
  context "When both address and google_map are present" do
    it "returns address and link to google_map" do
      expect(helper.link_to_google_map(address,
                                       google_map)).to eq("<a target=\"blank\" href=\"http://google.map\">My house address</a>")
    end
  end
  context "When there is no google_map" do
    let(:google_map) { "" }
    it "returns only address string" do
      expect(helper.link_to_google_map(address, google_map)).to eq("My house address")
    end
  end
  context "When there is no address or google_map" do
    let(:address) { "" }
    let(:google_map) { "" }
    it "returns a dash" do
      expect(helper.link_to_google_map(address, google_map)).to eq("-")
    end
  end
end
