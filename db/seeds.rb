# frozen_string_literal: true

# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

# https://catalog.data.gov/dataset/hospitals-dcdfc
# https://services1.arcgis.com/Hp6G80Pky0om7QvQ/arcgis/rest/services/Hospitals_1/FeatureServer/0/query?outFields=*&where=1%3D1
# see above for seeding the db

require 'net/http'
require 'json'

url = 'https://services1.arcgis.com/Hp6G80Pky0om7QvQ/arcgis/rest/services/Hospitals_1/FeatureServer/0/query?where=1%3D1&outFields=*&outSR=4326&f=json'
uri = URI(url)

response = Net::HTTP.get(uri)
json_response = JSON.parse(response)

FIELDS = %w[STATE CITY WEBSITE NAME TELEPHONE TRAUMA LONGITUDE LATITUDE ZIP ADDRESS COUNTRY].freeze
array_of_hospitals = json_response['features']

array_of_hospitals.each do |hospital|
  hospital['attributes'].each do |k, _v|
    next unless FIELDS.include?(k)

    Hospital.create(
      name: k['NAME'],
      address: k['ADDRESS'],
      state: k['STATE'],
      city: k['CITY'],
      zip_code: k['ZIP'],
      country: k['COUNTRY'],
      website: k['WEBSITE'],
      telephone: k['TELEPHONE'],
      trauma_level: k['TRAUMA'],
      longitude: k['LONGITUDE'],
      latitude: k['LATITUDE']
    )
  end
end
