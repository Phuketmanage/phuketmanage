Capybara.class_eval do
  def self.mock_browser_time(&block)
    @mock_browser_time = true
    yield block
    @mock_browser_time = false
  end

  def self.mock_browser_time?
    @mock_browser_time
  end
end
