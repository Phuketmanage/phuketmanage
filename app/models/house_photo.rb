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
