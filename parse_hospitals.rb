# frozen_string_literal: true

require 'net/http'
require 'json'



def array_of_hospitals
  url = 'https://services1.arcgis.com/Hp6G80Pky0om7QvQ/arcgis/rest/services/Hospitals_1/FeatureServer/0/query?where=1%3D1&outFields=*&outSR=4326&f=json'
  uri = URI(url)

  response = Net::HTTP.get(uri)
  json_response = JSON.parse(response)
  json_response['features']
end

def parse_hospital_fields
  fields = %w[STATE CITY WEBSITE NAME TELEPHONE TRAUMA LONGITUDE LATITUDE ZIP ADDRESS COUNTRY].freeze
  array_of_hospitals.each do |hospital|
    hospital['attributes'].each do |k, v|
      # next unless fields.include?(k)
      # next unless k == 'TRAUMA'
      next unless v == 'AREA' || v == 'PARC'

      p hospital
      puts k + ': ' + v.to_s
    end
  end
end

# Parse a trauma level string
# @param string [String] The trauma level to be parsed
# @return [Number, nil] Returns 1-5 or nil based on the given string
def parse_trauma_level(string)
  # Some hospitals listed as NOT DESIGNATED, others as NOT AVAILABLE
  # IF a hospital is both a an adult trauma & pedi trauma, its designated
  # "LEVEL I, LEVEL II PEDIATRIC"

  trauma_levels = 'I, II, III, IV, V, AREA, PARC'

  not_defined_strings = ['NOT AVAILABLE', 'NOT DEFINED']
  return nil if not_defined_strings.include?(string)

  # level
    # if k == 'TRAUMA' && v != 'NOT AVAILABLE'
    #   level = v.split('LEVEL ')[1]

    #   # v = level.length if level != 'IV' && level != 'V'

    #   v = 4 if level == 'IV'
    #   v = 5 if level == 'V'
    # end
end

parse_hospital_fields
