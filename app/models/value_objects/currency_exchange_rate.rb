require 'faraday'

module ValueObjects
  class CurrencyExchangeRate
    def initialize
      @response = fetch_exchange_rate
    end

    def get_rate
      JSON.parse(@response.body)['rates']['THB']
    end

    private

    def fetch_exchange_rate
      connection = Faraday.new(url: EXCHANGE_SERVER_URL)
      response   = connection.get("?app_id=#{EXCHANGE_APP_ID}")

      unless response.success?
        raise StandardError, "Failed to fetch exchange rate data"
      end

      response
    end
  end
end
