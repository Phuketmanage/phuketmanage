class Duration < ApplicationRecord
  belongs_to :house
  validates :start, :finish, :numericality => {
    greater_than: 1,
    less_than: 366 }
end
