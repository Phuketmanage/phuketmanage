class Duration < ApplicationRecord
  belongs_to :house
  validates :start, :finish, :numericality => {
    greater_than: 0,
    less_than: 366 }
end
