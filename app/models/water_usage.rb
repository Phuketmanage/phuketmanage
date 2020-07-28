class WaterUsage < ApplicationRecord
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
        self.errors.add(:amount, 'Can not be less then before') if amount.present? && before.last.amount.present? && amount < before.last.amount
        self.errors.add(:amount_2, 'Can not be less then before') if amount_2.present? && before.last.amount_2.present? && amount_2 < before.last.amount_2
      end
    end

    def overusage
      last = WaterUsage.where(house_id: house_id).order(:date).last
      if !last.nil?
        days = (date - last.date).to_i
        # byebug
        if amount.present? && last.amount.present? && (amount-last.amount).to_f/days > 1
          Notification.create!(
            house_id: house_id,
            text: "Water overusage #{amount-last.amount} units for #{(date - last.date).to_i} days. #{last.date.strftime('%d.%m')} - #{last.amount} units, #{date.in_time_zone('Bangkok').strftime('%d.%m')} - #{amount} units")

        end
        if amount_2.present? && last.amount_2.present? && (amount_2-last.amount_2).to_f/days > 1
          Notification.create!(
            house_id: house_id,
            text: "Water overusage #{amount_2-last.amount_2} units for #{(date - last.date).to_i} days. #{last.date.strftime('%d.%m')} - #{last.amount_2} units, #{date.in_time_zone('Bangkok').strftime('%d.%m')} - #{amount_2} units")
        end

      end
    end
end
