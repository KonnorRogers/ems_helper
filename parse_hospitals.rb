# frozen_string_literal: true

require 'net/http'
require 'json'
require 'rake'

def array_of_hospitals
  url = 'https://services1.arcgis.com/Hp6G80Pky0om7QvQ/arcgis/rest/services/Hospitals_1/FeatureServer/0/query?where=1%3D1&outFields=*&outSR=4326&f=json'
  uri = URI(url)

  response = Net::HTTP.get(uri)
  File.open("json-response", "w+") do |file|
    file.write(response)
  end

  json_response = JSON.parse(response)

  json_response['features']
end

def parse_hospital_fields
  fields = %w[STATE CITY WEBSITE NAME TELEPHONE TRAUMA LONGITUDE LATITUDE ZIP ADDRESS COUNTRY].freeze
  array_of_hospitals.each do |hospital|
    hospital['attributes'].each do |k, v|
      next unless fields.include?(k)
      next unless k == 'TRAUMA'

      # next unless v == 'AREA' || v == 'PARC'

      puts k + ': ' + parse_trauma_level(v).to_s
      # puts k + ': ' + v.to_s
    end
  end
end

# Parse a trauma level string
# @param string [String] The trauma level to be parsed
# @return [Number, nil] Returns 1-5 or nil based on the given string
def parse_trauma_level(string)
  # Some hospitals listed as NOT DESIGNATED, others as NOT AVAILABLE
  not_defined_strings = ['NOT AVAILABLE', 'NOT DEFINED']
  return nil if not_defined_strings.include?(string)

  trauma_levels = 'I, II, III, IV, V, AREA, PARC'

  level_string = string.gsub(/LEVEL/, '')

  # IF a hospital is both a an adult trauma & pedi trauma, its designated
  # "LEVEL I, LEVEL II PEDIATRIC"
  if level_string.include?(',')
    level_array = level_string.split(',')
    adult_str = level_array[0]
    pedi_str = level_array[1]
  end

  if level_string.include?('pediatric')

  end

  hash = {
    adult_str: '',
    pedi_str: ''
  }
end

# Only parses I, III, IV, V
def roman_numeral_to_int(str)
  return 4 if str == 'IV'
  return 5 if str == 'V'

  str.length
end

def parse_trauma_level_string(str)
  ary = str.split(' ')

  trauma_level = ary[1]

  # Maryland has one hospital that is a 'SARC', only hospital in US.
  # Make it easy, call it a level 1
  trauma_level = 'I' if trauma_level == 'SARC'

  # New york uses 'AREA' for level III trauma centers
  trauma_level = 'III' if trauma_level == 'AREA'
  roman_numeral_to_int(trauma_level)
end

# parse_hospital_fields
array_of_hospitals
