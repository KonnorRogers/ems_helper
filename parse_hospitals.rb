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
    next unless FIELDS.include?(k)

    if k == 'TRAUMA' && v != 'NOT AVAILABLE'
      level = v.split('LEVEL ')[1]

      v = 4 if level == 'IV'
      v = 5 if level == 'V'
      v = v.length if level != 'IV' || level != 'V'
    end

    puts k + ': ' + v.to_s
  end
end
