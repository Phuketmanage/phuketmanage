class Transaction < ApplicationRecord
  belongs_to :type, class_name: 'TransactionType'
  belongs_to :house
  belongs_to :user
  has_many :balances, dependent: :destroy
  has_many :balance_outs, dependent: :destroy

  validates :date, presence: true

  def set_owner
    if user_id.nil? && !house_id.nil?
      self.user_id = House.find(house_id).owner.id
    end
  end
end
