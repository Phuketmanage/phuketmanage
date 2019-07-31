class ResetTransfers < ActiveRecord::Migration[6.0]
  def change
    drop_table :transfers
    create_table :transfers do |t|
      t.references :booking, null: true, foreign_key: true
      t.date :date
      t.integer :trsf_type
      t.string :from
      t.string :time
      t.string :client
      t.string :pax
      t.string :to
      t.string :remarks
      t.string :booked_by
      t.string :number
      t.integer :status

      t.timestamps
    end
    add_index :transfers, :number
  end
end
