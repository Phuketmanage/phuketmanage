class HousePhoto < ApplicationRecord
  belongs_to :house

  def  original
    return "#{S3_HOST}#{url}"
  end

  def thumb
    url_parts = url.match(/^(.*[\/])(.*)$/)
    return "#{S3_HOST}#{url_parts[1]}thumb_#{url_parts[2]}"
  end

  def key
    return url
  end

  def thumb_key
    url_parts = url.match(/^(.*[\/])(.*)$/)
    return "#{url_parts[1]}thumb_#{url_parts[2]}"
  end

end
