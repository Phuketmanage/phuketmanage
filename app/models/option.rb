# == Schema Information
#
# Table name: options
#
#  id         :bigint           not null, primary key
#  title_en   :string
#  title_ru   :string
#  zindex     :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
class Option < ApplicationRecord
  has_many :house_options, dependent: :destroy
  has_many :houses, through: :house_options
end
