require 'faraday'

module ValueObjects
  class CurrencyExchangeRate
    URL         = 'https://openexchangerates.org/api/latest.json'
    YOUR_APP_ID = ENV['YOUR_APP_ID']

    def initialize
      @response = fetch_exchange_rate
    end

    def get_rate
      JSON.parse(@response.body)['rates']['THB']
    end

    def response_status
      @response.status
    end

    private

    def fetch_exchange_rate
      connection = Faraday.new(url: URL)
      response   = connection.get("?app_id=#{YOUR_APP_ID}")

      unless response.success?
        raise StandardError, "Failed to fetch exchange rate data"
      end

      response
    end
  end
end
