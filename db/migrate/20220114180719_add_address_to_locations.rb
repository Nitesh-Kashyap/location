class AddAddressToLocations < ActiveRecord::Migration[5.2]
  def change
    add_column :locations, :address, :text
    add_column :locations, :latitude, :float
    add_column :locations, :longitude, :float
  end
end
