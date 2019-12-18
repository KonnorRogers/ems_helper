# frozen_string_literal: true

require 'net/http'
require 'json'

# Define a TraumaLevel Struct which will allow you to access the level
# @param adult [Number, nil] - Adult trauma level (1-5 or nil)
# @param pediatric [Number, nil] - Pediatric trauma level (1-5 or nil)
TraumaLevel = Struct.new(:adult, :pediatric, keyword_init: true)

# @return Returns an array of hospitals from the url defined
def array_of_hospitals
  url = 'https://services1.arcgis.com/Hp6G80Pky0om7QvQ/arcgis/rest/services/Hospitals_1/FeatureServer/0/query?where=1%3D1&outFields=*&outSR=4326&f=json'
  uri = URI(url)

  response = Net::HTTP.get(uri)
  File.open('json-response', 'w+') do |file|
    file.write(response)
  end

  json_response = JSON.parse(response)

  json_response['features']
end

# @yield value [String]
def parse_hospital_fields
  fields = %w[STATE CITY WEBSITE NAME TELEPHONE TRAUMA LONGITUDE LATITUDE ZIP
              ADDRESS COUNTRY].freeze

  array_of_hospitals.each do |hospital|
    hospital['attributes'].each do |key, _value|
      next unless fields.include?(key)

      yield(hospital['attributes'])
    end
  end
end

# Parse a trauma level string
# @param string [String] The trauma level to be parsed
# @return [TraumaLevel] Returns a trauma level struct with adult & pediatric levels
def parse_trauma_levels(string)
  # Some hospitals listed as NOT DESIGNATED, others as NOT AVAILABLE
  not_defined_strings = ['NOT AVAILABLE', 'NOT DEFINED']
  # return nil if not_defined_strings.include?(string)

  level_string = string.gsub(/LEVEL /, '')

  adult_level = nil
  pediatric_level = nil
  # IF a hospital is both a an adult trauma & pedi trauma, its designated
  # "LEVEL I, LEVEL II PEDIATRIC"
  if level_string.include?(',')
    levels = parse_adult_and_pedi_trauma_level(level_string)

    pediatric_level = levels[:pediatric_level]
    adult_level = levels[:adult_level]
  else
    trauma_level = parse_trauma_level_string(level_string)

    pediatric_level = trauma_level if includes_pediatric_str?(level_string)
    adult_level = trauma_level unless includes_pediatric_str?(level_string)
  end

  TraumaLevel.new(adult: adult_level, pediatric: pediatric_level)
end

def parse_adult_and_pedi_trauma_level(str)
  level_array = str.split(', ')
  adult_str = level_array[0]
  pedi_str = level_array[1].gsub(/ PEDIATRIC/, '')

  adult_level = parse_trauma_level_string(adult_str)
  pediatric_level = parse_trauma_level_string(pedi_str)

  { adult_level: adult_level, pediatric_level: pediatric_level }
end

def includes_pediatric_str?(str)
  return true if str.include?('PEDIATRIC')
end

# Only parses I, III, IV, V
def roman_numeral_to_int(str)
  allowable_numerals = %w[I II III IV V]

  return nil unless allowable_numerals.include?(str)

  return 4 if str == 'IV'
  return 5 if str == 'V'

  str.length
end

def parse_trauma_level_string(trauma_level)
  # Maryland has one hospital that is a 'SARC', only hospital in US.
  # Make it easy, call it a level 1
  trauma_level = 'I' if trauma_level == 'SARC'

  # New york uses 'AREA' for level III trauma centers
  trauma_level = 'III' if trauma_level == 'AREA'

  roman_numeral_to_int(trauma_level)
end


Hospital = Struct.new(:name, :address, :city, :state, :country, :zip,
                      :phone_number, :adult_trauma, :pedi_trauma,
                      :latitude, :longitude, keyword_init: true)
def create_hospital_db
  parse_hospital_fields do |hospital|
    trauma_level = parse_trauma_levels(hospital['TRAUMA'])
    p trauma_level
    pedi_level = trauma_level.pediatric
    adult_level = trauma_level.adult

    new_hospital = Hospital.new(
      name: hospital['NAME'],
      address: hospital['ADDRESS'],
      city: hospital['CITY'],
      state: hospital['STATE'],
      country: hospital['COUNTRY'],
      zip: hospital['ZIP'].to_i,
      phone_number: hospital['TELEPHONE'],
      website: hospital['WEBSITE'],
      adult_trauma: adult_level,
      pedi_trauma: pedi_level,
      latitude: hospital['LATITUDE'],
      longitude: hospital['LONGITUDE']
    )

    p new_hospital
  end
end

create_hospital_db
