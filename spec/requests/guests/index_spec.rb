require 'rails_helper'

RSpec.describe "Guests::Index" do
  before do
    create(:house, :with_seasons)
  end

  describe "index" do
    it "returns http success" do
      get '/'
      expect(response).to have_http_status(:success)
    end

    context 'with locale' do
      it "returns http success" do
        get '/ru'
        expect(response).to have_http_status(:success)
      end
    end

    context 'when there is house with nil rooms' do
      before do
        create(:house, :with_seasons, rooms: nil)
      end

      it "returns http success" do
        get '/'
        expect(response).to have_http_status(:success)
      end
    end
  end
end
