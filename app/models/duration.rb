class Duration < ApplicationRecord
  the_schema_is "durations" do |t|
    t.integer "start"
    t.integer "finish"
    t.bigint "house_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  belongs_to :house
  validates :start, :finish, :numericality => {
    greater_than: 0,
    less_than: 366 }

  validate :not_overlapped

  def not_overlapped
    durations = House.find(house_id).durations
    overlapped = durations.where('start <= ? AND finish >= ?', finish, start)
    errors.add(:base, "There is at least one duration that overlapped with newly created duration period, need to change start or finish") if overlapped.any?
  end

end
