class Booking < ApplicationRecord
  enum status:  {
    temporary: 0,
    pending: 1,
    confirmed: 2,
    paid: 3,
    canceled: 4,
    changing: 5,
    block: 6 }
  belongs_to :house
  belongs_to :tenant, class_name: 'User', optional: true
  validate :price_chain

  def calc price
    self.sale = (price[:total]).round()
    self.agent = 0
    self.nett = (sale * (100-house.type.comm).to_f/100).round()
    self.comm = (sale - agent - nett).round()
  end

  private

    def price_chain
      if !self.block?
        if nett != sale - agent - comm
          errors.add(:base, "Check Prices: Sale - Agent - Comm is not equal to Nett")
        end
      end
    end

end
