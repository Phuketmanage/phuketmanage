class BookingFile < ApplicationRecord
  the_schema_is "booking_files" do |t|
    t.bigint "booking_id", null: false
    t.string "url"
    t.string "name"
    t.text "comment"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "user_id"
  end

  belongs_to :booking
  belongs_to :user, optional: true
  after_destroy :delete_file_from_s3

  def full_url
    return "#{S3_HOST}#{url}"
  end

  private
    def delete_file_from_s3
      S3_BUCKET.object(url).delete
    end

end
