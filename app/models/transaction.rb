class Transaction < ApplicationRecord
  belongs_to :type, class_name: 'TransactionType'
  belongs_to :house, optional: true
  belongs_to :user, optional: true
  has_many :balances, dependent: :destroy
  has_many :balance_outs, dependent: :destroy

  validates :date, presence: true

  def prepare (type, de_ow, cr_ow, de_co, cr_co)
    types1 = ['Maintenance', 'Laundry']
    types2 = ['Rental']
    types3 = ['Top up', 'Utilities received']
    types4 = ['Repair', 'Purchases']
    types5 = ['Utilities', 'Pest control', 'Insurance', 'Salary', 'Gasoline', 'Office', 'Suppliers', 'Equipment']
    if types1.include?(type)
      balance_outs.create!(credit: cr_ow)
      balances.create!(debit: cr_ow)
    elsif types2.include?(type)
      balance_outs.create!(debit: de_ow, credit: de_co)
      balances.create!(debit: de_co)
    elsif types3.include?(type)
      balance_outs.create!(debit: de_ow)
    elsif types4.include?(type)
      balance_outs.create!(credit: cr_ow)
      balance_outs.create!(credit: cr_co + de_co)
      balances.create!(debit: de_co, credit: cr_co)
    elsif types5.include?(type)
      balance_outs.create!(credit: cr_ow) if cr_ow > 0
      balances.create!(credit: cr_co) if cr_co > 0
    else
      errors.add(:base, 'Transaction type is not programmed')

    end
  end

  def set_owner
    if user_id.nil? && !house_id.nil?
      self.user_id = House.find(house_id).owner.id
    end
  end
end
