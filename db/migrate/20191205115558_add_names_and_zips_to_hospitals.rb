class AddNamesAndZipsToHospitals < ActiveRecord::Migration[6.0]
  def change
    add_column :hospitals, :name, :string
    add_column :hospitals, :zip, :integer
  end
end
