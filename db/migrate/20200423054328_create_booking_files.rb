class CreateBookingFiles < ActiveRecord::Migration[6.0]
  def change
    create_table :booking_files do |t|
      t.references :booking, null: false, foreign_key: true
      t.string :url
      t.string :name
      t.text :comment

      t.timestamps
    end
  end
end
