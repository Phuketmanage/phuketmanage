class Price < ApplicationRecord
  belongs_to :house
  validates :amount, presence: true
  validates :amount, :numericality => {
    greater_than: 0,
    less_than: 366 }
end
