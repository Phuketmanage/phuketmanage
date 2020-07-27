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
        self.errors.add(:amount, 'Can not be less then before') if amount < before.last.amount
      end
    end

    def overusage
      last = WaterUsage.where(house_id: house_id).order(:date).last
      if !last.nil?
        days = (date - last.date).to_i
        # byebug
        if (amount-last.amount).to_f/days > 1
          Notification.create!(
            house_id: house_id,
            text: "Water overusage #{amount-last.amount} units for #{(date - last.date).to_i} days. #{last.date.strftime('%d.%m')} - #{last.amount} units, #{date.in_time_zone('Bangkok').strftime('%d.%m')} - #{amount} units")

        end
      end
    end
end
