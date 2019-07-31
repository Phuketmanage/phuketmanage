class RemoveAddDateTransfer < ActiveRecord::Migration[6.0]
  def change
      if Transfer.attribute_names.include? "date"
        remove_column :transfers, :date
        add_column :transfers, :date, :date
      end
    end
end
