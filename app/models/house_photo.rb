class HousePhoto < ApplicationRecord
  the_schema_is "house_photos" do |t|
    t.bigint "house_id", null: false
    t.string "url"
    t.string "title_en"
    t.string "title_ru"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

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
