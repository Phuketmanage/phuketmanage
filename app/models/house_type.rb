# == Schema Information
#
# Table name: house_types
#
#  id         :bigint           not null, primary key
#  comm       :integer
#  name_en    :string
#  name_ru    :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
class HouseType < ApplicationRecord
  has_many :houses, dependent: :nullify, foreign_key: 'type_id'
end
