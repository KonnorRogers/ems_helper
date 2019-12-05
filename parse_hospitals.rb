require 'net/http'
require 'json'

# url = "https://services1.arcgis.com/Hp6G80Pky0om7QvQ/arcgis/rest/services/Hospitals_1/FeatureServer/0/query?outFields=*&where=1%3D1"
# url = "https://opendata.arcgis.com/datasets/6ac5e325468c4cb9b905f1728d6fbf0f_0.geojson"
url = "https://services1.arcgis.com/Hp6G80Pky0om7QvQ/arcgis/rest/services/Hospitals_1/FeatureServer/0/query?where=1%3D1&outFields=*&outSR=4326&f=json"
uri = URI(url)

response = Net::HTTP.get(uri)
json_response = JSON.parse(response)

FIELDS = %w[STATE CITY WEBSITE NAME TELEPHONE TRAUMA LONGITUDE LATITUDE ZIP ADDRESS COUNTRY]
array_of_hospitals = json_response["features"]

array_of_hospitals.each do |hospital|
  hospital["attributes"].each do |k, v|
    puts k + ": " + v.to_s
  end
end
