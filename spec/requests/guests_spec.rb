require 'rails_helper'

RSpec.describe "Guests", type: :request do
  before do
    create(:house, :with_seasons)
  end

  describe "GET root page" do
    it "returns http success" do
      get '/'
      expect(response).to have_http_status(:success)
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

  describe "GET root page with locale" do
    it "returns http success with :ru locale" do
      get '/ru'
      expect(response).to have_http_status(:success)
    end

    it "returns http success with :en locale" do
      get '/en'
      expect(response).to have_http_status(:success)
    end
  end
end
