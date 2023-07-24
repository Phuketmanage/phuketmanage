class Price < ApplicationRecord
  the_schema_is "prices" do |t|
    t.bigint "house_id", null: false
    t.integer "season_id"
    t.integer "duration_id"
    t.integer "amount"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  belongs_to :house
  belongs_to :season
  belongs_to :duration
  validates :amount, presence: true
  validates :amount, numericality: { greater_than_or_equal_to: 0 }
end
