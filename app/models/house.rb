class House < ApplicationRecord
  belongs_to :owner, class_name: "User"
  has_many :bookings, dependent: :destroy
  has_many :prices, dependent: :destroy
  has_many :seasons, dependent: :destroy
  has_many :durations, dependent: :destroy
end
