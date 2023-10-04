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

  def self.sync_usd_rate
    rate = self.get_usd_rate
    update_usd_rate(rate)
  end

  private

  def self.get_usd_rate
    rate    = ValueObjects::CurrencyExchangeRate.new
    thb     = rate.get_rate
    percent = thb / 100.0
    (thb - percent).to_i
  end

  def self.update_usd_rate(rate)
    find_by(var: 'usd_rate').update(value: rate)
  end
end
