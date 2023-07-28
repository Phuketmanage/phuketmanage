require 'rails_helper'

RSpec.describe "Translations" do
  let(:user) { create(:user, :owner) }

  describe "GET /translate" do
    context 'when unauthorized' do
      it "returns http 302 Found" do
        get translate_path
        expect(response).to have_http_status(:found)
      end
    end

    context 'when authorized' do
      login_manager

      it "returns http success" do
        get translate_path
        expect(response).to have_http_status(:success)
      end

      it "translates the text" do
        VCR.use_cassette('translation_ru2en') do
          get translate_path(language: :en, text: "Переведи этот текст")
        end
        expect(response.body).to eq("Translate this text")
      end
    end
  end
end
