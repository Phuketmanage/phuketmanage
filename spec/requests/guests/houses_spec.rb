require 'rails_helper'

RSpec.describe "Guests::Houses", freeze: '2023-02-01' do
  let(:current_date) { '2023-02-01'.to_date }
  let(:period_from) { 10.days.from_now.to_date.to_fs }
  let(:period_to) { 20.days.from_now.to_date.to_fs }
  let(:house) { create(:house) }

  describe "index" do
    context "without params" do
      it "redirects to index" do
        get '/houses'
        expect(response).to redirect_to('/')
      end

      it "redirects to index with locale" do
        get '/ru/houses'
        expect(response).to redirect_to('/ru')
      end
    end

    context "with search params" do
      before do
        get "/houses?search%5Bperiod%5D=#{period_from}+-+#{period_to}&commit=Search"
      end

      it "returns http success" do
        expect(response).to have_http_status(:success)
      end
    end

    context "with locale and search params" do
      before do
        get "/ru/houses?search%5Bperiod%5D=#{period_from}+-+#{period_to}&commit=Search"
      end

      it "returns http success" do
        expect(response).to have_http_status(:success)
      end
    end
  end

  describe "show" do
    it "returns http success" do
      get guests_house_path(id: house.number)
      expect(response).to have_http_status(:success)
    end

    context 'with locale' do
      it "returns http success" do
        get guests_house_path(locale: :ru, id: house.number)
        expect(response).to have_http_status(:success)
      end
    end
  end
end
