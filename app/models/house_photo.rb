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
