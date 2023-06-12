class Log < ApplicationRecord
  the_schema_is "logs" do |t|
    t.string "where"
    t.text "before"
    t.text "after"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "who"
    t.string "what"
    t.string "with"
  end
  validates :who, :where, :what, :with, :before, :after, presence: true

  private

  def add(who, where, what, with, before, after)
  end
end
