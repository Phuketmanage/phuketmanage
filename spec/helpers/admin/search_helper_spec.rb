require 'rails_helper'

RSpec.describe Admin::SearchHelper, type: :helper do
  describe "#generated_link_to_guests_search" do
    before do
      allow(helper)
        .to receive(:params)
        .and_return(params)
    end

    context "when search param is present" do
      let(:params) do
        ActionController::Parameters.new(search: { period: "week", type: [0, 1], bdr: [2, 3], location: [4, 5] })
      end

      it "returns the correct URL when all required parameters are present" do
        expect(helper.generated_link_to_guests_search).to eq guests_houses_url(search: { period: "week", type: [0, 1],
                                                                                         bdr: [2, 3], location: [4, 5] })
      end
    end

    context "when search param is empty" do
      let(:params) { ActionController::Parameters.new }

      it "returns the correct URL when no required parameters are present" do
        expect(helper.generated_link_to_guests_search).to eq guests_houses_url
      end
    end
  end
end
