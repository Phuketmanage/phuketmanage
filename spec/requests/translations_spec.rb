require 'rails_helper'

RSpec.describe "Translations", type: :request do
  describe "GET /show" do
    it "returns http success" do
      pending("Still WIP")
      get "/translations/show"
      expect(response).to have_http_status(:success)

      raise "broken"
    end
  end
end
