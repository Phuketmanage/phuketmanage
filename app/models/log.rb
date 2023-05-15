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

  private

  def add(user, controller, before, after); end
end
