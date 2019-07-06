class HouseType < ApplicationRecord
  has_many :houses, dependent: :nullify, foreign_key: 'type_id'

end
