class Source < ApplicationRecord
  the_schema_is "sources" do |t|
    t.string "name"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.boolean "syncable", default: false
  end

  has_many :connections, dependent: :destroy
  has_many :bookings, dependent: :nullify
  validates :name, presence: true
  scope :syncable, -> { where(syncable: true) }

end
