class CreateUploadsTests < ActiveRecord::Migration[7.0]
  def change
    create_table :uploads_tests do |t|

      t.timestamps
    end
  end
end
