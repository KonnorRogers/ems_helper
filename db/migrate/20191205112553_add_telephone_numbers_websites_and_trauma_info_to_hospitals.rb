class AddTelephoneNumbersWebsitesAndTraumaInfoToHospitals < ActiveRecord::Migration[6.0]
  def change
    add_column :hospitals, :phone_number, :string
    add_column :hospitals, :pediatric_trauma_level, :integer
    add_column :hospitals, :adult_trauma_level, :integer
    add_column :hospitals, :website, :string
  end
end
