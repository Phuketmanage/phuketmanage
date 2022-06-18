class AddCommentToWaterUsage < ActiveRecord::Migration[6.0]
  def change
    add_column :water_usages, :comment, :string
  end
end
