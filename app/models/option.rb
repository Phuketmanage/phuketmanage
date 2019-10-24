class Option < ApplicationRecord
  has_many :house_options, dependent: :destroy
  has_many :houses, through: :house_options
end
