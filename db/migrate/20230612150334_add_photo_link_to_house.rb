class AddPhotoLinkToHouse < ActiveRecord::Migration[6.1]
  def change
    add_column :houses, :photo_link, :string
  end
end
