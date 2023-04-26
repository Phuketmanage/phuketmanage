class WaterUsage < ApplicationRecord
  the_schema_is "water_usages" do |t|
    t.bigint "house_id", null: false
    t.date "date"
    t.integer "amount"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.integer "amount_2"
    t.string "comment"
  end

  belongs_to :house

  validates :amount, presence: true
  validates :amount, numericality: { greater_than: 0 }
  validate :only_one_per_day, on: :create
  validate :only_greater, on: :create
  validate :overusage, on: :create

  private

  def only_one_per_day
    already = WaterUsage.where(house_id: house_id, date: date)
    already.destroy_all if already.any?
  end

  def only_greater
    before = WaterUsage.where(house_id: house_id).order(:date)
    if before.any?
      if amount.present? && before.last.amount.present? && amount < before.last.amount
        errors.add(:amount,
                   'Can not be less then before')
      end
      if amount_2.present? && before.last.amount_2.present? && amount_2 < before.last.amount_2
        errors.add(:amount_2,
                   'Can not be less then before')
      end
    end
  end

  def overusage
    last = WaterUsage.where(house_id: house_id).order(:date).last
    unless last.nil?
      days = (date - last.date).to_i
      if amount.present? && last.amount.present? && (amount - last.amount).to_f / days > 1
        text = "Water overusage: #{amount}(#{date.in_time_zone('Bangkok').strftime('%d.%m')}) - #{last.amount}(#{last.date.in_time_zone('Bangkok').strftime('%d.%m')}) = #{amount - last.amount} in #{(date - last.date).to_i} days"
        Notification.create!(
          house_id: house_id,
          text: text
        )
        send_sms(message: "#{House.find(house_id).code}: #{text}")
      end
      if amount_2.present? && last.amount_2.present? && (amount_2 - last.amount_2).to_f / days > 1
        text = "Water overusage: #{amount_2}(#{date.in_time_zone('Bangkok').strftime('%d.%m')}) - #{last.amount_2}(#{last.date.in_time_zone('Bangkok').strftime('%d.%m')}) = #{amount_2 - last.amount_2} in #{(date - last.date).to_i} days"
        Notification.create!(
          house_id: house_id,
          text: text
        )
        send_sms(message: "#{House.find(house_id).code} #{text} /2nd meter")
      end

    end
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
