# == Schema Information
#
# Table name: house_groups
#
#  id         :bigint           not null, primary key
#  name       :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
class HouseGroup < ApplicationRecord
  has_many :houses, dependent: :nullify
end
