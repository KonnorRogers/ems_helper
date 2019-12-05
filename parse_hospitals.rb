# frozen_string_literal: true

require 'net/http'
require 'json'

url = 'https://services1.arcgis.com/Hp6G80Pky0om7QvQ/arcgis/rest/services/Hospitals_1/FeatureServer/0/query?where=1%3D1&outFields=*&outSR=4326&f=json'
uri = URI(url)

response = Net::HTTP.get(uri)
json_response = JSON.parse(response)

FIELDS = %w[STATE CITY WEBSITE NAME TELEPHONE TRAUMA LONGITUDE LATITUDE ZIP ADDRESS COUNTRY].freeze
array_of_hospitals = json_response['features']

array_of_hospitals.each do |hospital|
  hospital['attributes'].each do |k, v|
    next unless FIELDS.includes?(k)

    puts k + ': ' + v.to_s
  end
end
