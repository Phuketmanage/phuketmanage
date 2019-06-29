class CreateBookings < ActiveRecord::Migration[6.0]
  def change
    create_table :bookings do |t|
      t.date :start
      t.date :finish
      t.references :house, null: false, foreign_key: true
      t.references :tenant, null: false, foreign_key: {to_table: :users}

      t.timestamps
    end
  end
end
