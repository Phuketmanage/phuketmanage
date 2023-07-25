module CapybaraMacros
  def scroll_to_bottom
    page.execute_script 'window.scrollBy(0,10000)'
  end

  def wait_for_ajax
    Timeout.timeout(Capybara.default_max_wait_time) do
      loop until finished_all_ajax_requests?
    end
  end

  def finished_all_ajax_requests?
    page.evaluate_script('jQuery.active').zero?
  end

  def pause_selenium
    $stderr.write 'Press enter to continue'
    $stdin.gets
  end

  def maximize_browser_window
    Capybara.current_session.current_window.resize_to(1000, 1000)
  end
end

RSpec.configure do |config|
  config.include CapybaraMacros, type: :feature
  config.include Warden::Test::Helpers
end
