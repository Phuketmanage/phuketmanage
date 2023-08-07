# == Schema Information
#
# Table name: house_photos
#
#  id         :bigint           not null, primary key
#  position   :integer
#  title_en   :string
#  title_ru   :string
#  url        :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  house_id   :bigint           not null
#
# Indexes
#
#  index_house_photos_on_house_id  (house_id)
#
# Foreign Keys
#
#  fk_rails_...  (house_id => houses.id)
#
class HousePhoto < ApplicationRecord
  belongs_to :house

  include RankedModel
  ranks :position

  def original
    "#{S3_HOST}#{url}"
  end

  def thumb
    url_parts = url.match(%r{^(.*/)(.*)$})
    "#{S3_HOST}#{url_parts[1]}thumb_#{url_parts[2]}"
  end

  def key
    url
  end

  def thumb_key
    url_parts = url.match(%r{^(.*/)(.*)$})
    "#{url_parts[1]}thumb_#{url_parts[2]}"
  end
end
