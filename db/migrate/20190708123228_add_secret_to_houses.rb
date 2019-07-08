class AddSecretToHouses < ActiveRecord::Migration[6.0]
  def change
    add_column :houses, :secret, :string
  end
end
