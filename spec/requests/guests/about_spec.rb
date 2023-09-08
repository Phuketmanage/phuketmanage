require 'rails_helper'

RSpec.describe "Guests::About" do
  describe "index" do
    it "returns http success" do
      get '/about'
      expect(response).to have_http_status(:success)
    end

    context 'with locale' do
      it "returns http success" do
        get '/ru/about'
        expect(response).to have_http_status(:success)
      end
    end
  end
end
