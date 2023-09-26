class ExchangeRateJob < ApplicationJob
  def perform
    Setting.get_usd_rate
  end
end
