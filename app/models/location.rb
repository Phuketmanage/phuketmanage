# == Schema Information
#
# Table name: locations
#
#  id         :bigint           not null, primary key
#  descr_en   :text
#  descr_ru   :text
#  name_en    :string
#  name_ru    :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
class Location < ApplicationRecord
  include Translatable
  has_and_belongs_to_many :houses

  translates :name, :descr
end
