# frozen_string_literal: true

# The Hospital is where the data is stored. IE: address, geocode, long, lat etc
class Hospital < ApplicationRecord
  geocoded_by :address
  after_validation :geocode, if: ->(hospital) { hospital.update_geocode? }

  # @see https://github.com/alexreisner/geocoder#geocoding-objects
  def address
    [street, city, state, country].compact.join(', ')
  end

  private

  # Only update the geocode if the hospital does not have a long / lat specified
  # And when the address changes & is present
  def update_geocode?
    return false if longitude.present? && hospital.latitude.present?
    return false unless address.present?
    return false unless address.changed?

    true
  end
end
