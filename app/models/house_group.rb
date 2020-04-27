class HouseGroup < ApplicationRecord
  has_many :houses, dependent: :nullify
end
