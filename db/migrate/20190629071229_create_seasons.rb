class CreateSeasons < ActiveRecord::Migration[6.0]
  def change
    create_table :seasons do |t|
      t.integer :ssd
      t.integer :ssm
      t.integer :sfd
      t.integer :sfm
      t.references :house, null: false, foreign_key: true

      t.timestamps
    end
  end
end
