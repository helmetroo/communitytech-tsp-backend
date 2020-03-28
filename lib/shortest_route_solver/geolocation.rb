require 'google_distance_matrix'

class Geolocation
  def initialize(latitude: 0, longitude: 0)
    @latitude = latitude
    @longitude = longitude
  end

  public
  def latitude
    @latitude
  end

  public
  def longitude
    @longitude
  end

  public
  def to_distance_matrix_place
    GoogleDistanceMatrix::Place.new(lat: @latitude, lng: @longitude)
  end

  public
  def to_postgis_point
    %(ST_SetSRID(ST_MakePoint(#{@latitude}, #{@longitude}), 4326))
  end
end
