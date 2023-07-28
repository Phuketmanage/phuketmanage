require 'rails_helper'

RSpec.describe "Translations" do
  let(:user) { create(:user, :account) }

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
        stub_request(:post, "https://translation.googleapis.com/language/translate/v2?key=AIzaSyDZps_zndKZ7PopkO46xAfJhuwFWCHbiz8&prettyPrint=false&target=en")
          .to_return(status: 200, body: '{"data":{"translations":[{"translatedText":"Translate this text","detectedSourceLanguage":"ru"}]}}')

        get translate_path(language: :en, text: "Переведи этот текст")

        expect(response.body).to eq("Translate this text")
      end
    end
  end
end
