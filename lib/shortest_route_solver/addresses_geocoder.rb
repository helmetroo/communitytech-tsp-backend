require 'geocoder'

require_relative './geolocation'

class AddressesGeocoder
  public
  def self.geocode(addresses = [])
    geolocations = []

    addresses.each_with_index do |address, index|
      search_results = Geocoder.search(address)
      if search_results.empty?
        geolocations << nil
        next
      end

      best_result = search_results.first
      if best_result.nil?
        geolocations << nil
        next
      end

      geolocation = Geolocation.new(latitude: best_result.latitude, longitude: best_result.longitude)
      geolocations << geolocation
    end

    geolocations
  end
end
