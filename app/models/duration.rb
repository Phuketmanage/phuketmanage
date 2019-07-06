class Duration < ApplicationRecord
  belongs_to :house
  validates :start, :finish, :numericality => { greater_than_or_equal_to: 1 }
end
