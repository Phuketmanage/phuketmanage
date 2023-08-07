# == Schema Information
#
# Table name: water_usages
#
#  id         :bigint           not null, primary key
#  amount     :integer
#  amount_2   :integer
#  comment    :string
#  date       :date
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  house_id   :bigint           not null
#
# Indexes
#
#  index_water_usages_on_house_id  (house_id)
#
# Foreign Keys
#
#  fk_rails_...  (house_id => houses.id)
#
class WaterUsage < ApplicationRecord
  belongs_to :house

  validates :amount, presence: true
  validates :amount, numericality: { greater_than: 0 }
  validate :only_one_per_day, on: :create
  validate :only_greater, on: :create
  validate :overusage, on: :create

  private

  def only_one_per_day
    already = WaterUsage.where(house_id:, date:)
    already.destroy_all if already.any?
  end

  def only_greater
    before = WaterUsage.where(house_id:).order(:date)
    return unless before.any?

    if amount.present? && before.last.amount.present? && amount < before.last.amount
      errors.add(:amount,
                 'Can not be less then before')
    end
    return unless amount_2.present? && before.last.amount_2.present? && amount_2 < before.last.amount_2

    errors.add(:amount_2,
               'Can not be less then before')
  end

  def overusage
    last = WaterUsage.where(house_id:).order(:date).last
    return if last.nil?

    days = (date - last.date).to_i
    if amount.present? && last.amount.present? && (amount - last.amount).to_f / days > 1
      text = "Water overusage: #{amount}(#{date.to_fs(:day_month)}) - #{last.amount}(#{last.date.to_fs(:day_month)}) = #{amount - last.amount} in #{(date - last.date).to_i} days"
      Notification.create!(
        house_id:,
        text:
      )
      send_sms(message: "#{House.find(house_id).code}: #{text}")
    end
    return unless amount_2.present? && last.amount_2.present? && (amount_2 - last.amount_2).to_f / days > 1

    text = "Water overusage: #{amount_2}(#{date.to_fs(:day_month)}) - #{last.amount_2}(#{last.date.to_fs(:day_month)}) = #{amount_2 - last.amount_2} in #{(date - last.date).to_i} days"
    Notification.create!(
      house_id:,
      text:
    )
    send_sms(message: "#{House.find(house_id).code} #{text} /2nd meter")
  end

  def send_sms(message:, phone: '+66875558155')
    client = Twilio::REST::Client.new
    client.messages.create(
      from: ENV.fetch('TWILIO_PHONE_NUMBER', nil),
      to: "#{phone}",
      body: message
    )
  end
end
