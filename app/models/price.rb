class Price < ApplicationRecord
  belongs_to :house
  belongs_to :season
  belongs_to :duration
  validates :amount, presence: true
  validates :amount, numericality: { greater_than_or_equal_to: 0 }
end
