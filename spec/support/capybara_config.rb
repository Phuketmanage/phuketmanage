RSpec.configure do |config|
  # Default driver without js support for faster tests
  config.before(:each, type: :system) do
    driven_by :rack_test
  end
  # Use Chrome headless to test js
  config.before(:each, js: true, type: :system) do
    driven_by :selenium_chrome_headless
    Capybara.page.current_window.resize_to(1200, 768)
  end
  # Use Chrome to open browser window
  config.before(:each, js_visual: true, type: :system) do
    driven_by :selenium_chrome
    Capybara.page.current_window.resize_to(1200, 768)
  end
end
