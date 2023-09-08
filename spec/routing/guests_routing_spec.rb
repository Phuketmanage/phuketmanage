require 'rails_helper'

RSpec.describe "Guests routes" do
  it "routes GET / to guests/index#index" do
    expect(get: "/").to route_to(controller: "guests/index", action: "index")
  end

  it "routes GET /:locale to guests/index#index" do
    expect(get: "/ru").to route_to(controller: "guests/index", action: "index", locale: "ru")
  end

  it "routes GET /houses to guests/houses#index" do
    expect(get: "/houses").to route_to(controller: "guests/houses", action: "index")
  end

  it "routes GET /houses/:id to guests/houses#show" do
    expect(get: "/houses/1").to route_to(controller: "guests/houses", action: "show", id: "1")
  end

  it "routes GET /about to guests/about#index" do
    expect(get: "/about").to route_to(controller: "guests/about", action: "index")
  end
end
