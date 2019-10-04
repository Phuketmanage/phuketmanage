class Transaction < ApplicationRecord
  belongs_to :type, class_name: 'TransactionType'
  belongs_to :house, optional: true
  belongs_to :user, optional: true
  belongs_to :booking, optional: true
  has_many :balances, dependent: :destroy
  has_many :balance_outs, dependent: :destroy

  validates :date, :type, :comment_en, presence: true

  def write_to_balance (type, de_ow, cr_ow, de_co, cr_co)
    types1 = ['Rental']
    types2 = ['Maintenance', 'Laundry']
    types3 = ['Top up', 'From guests']
    types4 = ['Repair', 'Purchases']
    types5 = ['Utilities', 'Pest control', 'Insurance', 'To owner', 'Common area', 'Salary', 'Gasoline', 'Office', 'Suppliers', 'Equipment']
    types6 = ['Other']
    # Может быт balances и balance_outs будут не нужна если под все операции подойдет одна строка в Transactions
    balance_outs.destroy_all if balance_outs.any?
    balances.destroy_all if balances.any?
    if types1.include?(type)
      errors.add(:base, 'Need to select owner or house') and return if house_id.nil? && user_id.nil?
      balance_outs.create!(debit: de_ow, credit: de_co)
      balances.create!(debit: de_co)
    elsif types2.include?(type)
      errors.add(:base, 'Amount can not be blank') if cr_ow.nil? || cr_ow == 0
      errors.add(:base, 'Need to select owner or house') if house_id.nil? && user_id.nil?
      return if errors.any?
      balance_outs.create!(credit: cr_ow)
      balances.create!(debit: cr_ow)
    elsif types3.include?(type)
      errors.add(:base, 'Need to select owner or house') and return if house_id.nil? && user_id.nil?
      balance_outs.create!(debit: de_ow)
    elsif types4.include?(type)
      errors.add(:base, 'Need to select house') and return if house_id.nil?
      balance_outs.create!(credit: cr_ow + cr_co + de_co)
      balances.create!(debit: cr_co + de_co, credit: cr_co)
    elsif types5.include?(type)
      balance_outs.create!(credit: cr_ow) if cr_ow > 0
      balances.create!(credit: cr_co) if cr_co > 0
    elsif types6.include?(type)
      balance_outs.create!(debit: de_ow, credit: cr_ow)
      balances.create!(debit: de_co, credit: cr_co)
    else
      errors.add(:base, 'Transaction type is not programmed yet')

    end
  end

  def set_owner_and_house
    if user_id.nil? && !house_id.nil?
      self.user_id = House.find(house_id).owner.id
    end

    if user_id.nil? && !booking_id.nil?
      house = Booking.find(booking_id).house
      self.house_id = house.id
      self.user_id = house.owner.id
    end
  end
end
