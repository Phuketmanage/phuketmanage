# == Schema Information
#
# Table name: settings
#
#  id          :bigint           not null, primary key
#  description :string
#  value       :string
#  var         :string
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#
class Setting < ApplicationRecord
  def self.get_usd_rate
    rate    = ValueObjects::CurrencyExchangeRate.new
    thb     = rate.get_rate
    percent = thb / 100.0
    (thb - percent).to_i
  end
end
