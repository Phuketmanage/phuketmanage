require 'rails_helper'

RSpec.describe Admin::AdminHousesHelper, type: :helper do
  let(:address) { "My house address" }
  let(:google_map) { "http://google.map" }

  describe "#link_to_google_map" do
    context "when both address and google_map are present" do
      it "returns address and link to google_map" do
        expect(helper.link_to_google_map(address,
                                         google_map)).to eq("<a target=\"blank\" href=\"http://google.map\">My house address</a>")
      end
    end

    context "when there is no google_map" do
      let(:google_map) { "" }

      it "returns only address string" do
        expect(helper.link_to_google_map(address, google_map)).to eq("My house address")
      end
    end

    context "when there is no address or google_map" do
      let(:address) { "" }
      let(:google_map) { "" }

      it "returns a dash" do
        expect(helper.link_to_google_map(address, google_map)).to eq("-")
      end
    end
  end

  describe "#generated_link_to_guests_house" do
    let(:house) { create(:house) }

    before do
      allow(helper)
        .to receive(:params)
        .and_return(params)
    end

    context "when search param is present" do
      let(:params) do
        ActionController::Parameters.new(period: "week")
      end

      it "returns the correct URL when all required parameters are present" do
        expect(helper.generated_link_to_guests_house(house)).to eq guests_house_url(id: house.number,
                                                                                    params: { period: "week" })
      end
    end

    context "when search param is empty" do
      let(:params) { ActionController::Parameters.new }

      it "returns the correct URL when no required parameters are present" do
        expect(helper.generated_link_to_guests_house(house)).to eq guests_house_url(id: house.number)
      end
    end
  end
end
