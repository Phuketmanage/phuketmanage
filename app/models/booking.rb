class Booking < ApplicationRecord
  belongs_to :house
  belongs_to :tenant, class_name: 'User'
end
