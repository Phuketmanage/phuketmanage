class CreateConnections < ActiveRecord::Migration[6.0]
  def change
    create_table :connections do |t|
      t.references :house, null: false, foreign_key: true
      t.references :source, null: false, foreign_key: true
      t.string :link

      t.timestamps
    end
  end
end
