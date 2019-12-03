class AddLatitudeAndLongitudeIndexToHospitals < ActiveRecord::Migration[6.0]
  def change
    add_index :hospitals, [:latitude, :longitude]
  end
end
