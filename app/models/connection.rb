class Connection < ApplicationRecord
  the_schema_is "connections" do |t|
    t.bigint "house_id", null: false
    t.bigint "source_id", null: false
    t.string "link"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.datetime "last_sync"
  end

  belongs_to :house
  belongs_to :source
  validates :source_id, :house_id, presence: true
  validates :house_id, uniqueness: { scope: :source_id, message: "Only one link allowed for each source" }
  validates :link, uniqueness: true
end
