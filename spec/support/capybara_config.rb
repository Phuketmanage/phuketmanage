RSpec.configure do |config|
  # Default driver without js support for faster tests
  config.before(:each, type: :system) do
    driven_by :rack_test
  end
  # Use Chrome headless to test js
  config.before(:each, type: :system, js: true) do
    driven_by :selenium_chrome_headless
    Capybara.page.current_window.resize_to(1024, 768)
  end
  # Use Chrome to open browser window
  config.before(:each, type: :system, js_visual: true) do
    driven_by :selenium_chrome
    Capybara.page.current_window.resize_to(1024, 768)
  end
end