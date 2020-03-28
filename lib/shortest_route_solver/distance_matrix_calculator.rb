# Needed for google_distance_matrix. By default it doesn't think Net:HTTP exists... dunno why.
require 'net/http'

require 'google_distance_matrix'

class DistanceMatrixCalculator
  public
  def self.calculate(origin: Geolocation.new(), destinations: [])
    # Adapted from https://developers.google.com/optimization/routing/vrp#compute_matrix
    # The API only accepts up to 100 elements per request,
    # so we need to accumulate rows for the matrix in multiple requests
    max_elements = 100
    num_addresses = destinations.length + 1
    max_rows = max_elements / num_addresses
    num_requests, remaining_rows = num_addresses.divmod(max_rows)
    all_addresses = [origin, *destinations]
    adjacency_matrix = []
    for request in 0..(num_requests - 1)
      address_range_min = request * max_rows
      address_range_max = ((request + 1) * max_rows) - 1
      origins = all_addresses[address_range_min..address_range_max]

      distances =
        DistanceMatrixCalculator.fetch_distances(origins: origins, destinations: all_addresses)

      distance_matrix =
        DistanceMatrixCalculator.build_distance_matrix(distances: distances)

      adjacency_matrix.concat(distance_matrix)
    end

    # Handle the remaining rows (if there are any)
    if remaining_rows > 0
      address_range_min = num_requests * max_rows
      address_range_max = (num_requests * max_rows + remaining_rows) - 1
      origins = all_addresses[address_range_min..address_range_max]

      distances =
        DistanceMatrixCalculator.fetch_distances(origins: origins, destinations: all_addresses)

      distance_matrix =
        DistanceMatrixCalculator.build_distance_matrix(distances: distances)

      adjacency_matrix.concat(distance_matrix)
    end

    adjacency_matrix
  end

  protected
  def self.fetch_distances(origins: [], destinations: [])
    distance_matrix = GoogleDistanceMatrix::Matrix.new

    origins.each do |origin|
      distance_matrix.origins << origin.to_distance_matrix_place
    end

    destinations.each do |dest|
      distance_matrix.destinations << dest.to_distance_matrix_place
    end

    distance_matrix.configure do |config|
      #TODO allow this to be configurable (walking, tolls don't matter, etc)
      config.mode = 'driving'
      config.avoid = 'tolls'

      config.google_api_key = ENV['GOOGLE_MAPS_API_KEY']
    end

    distance_matrix.data
  end

  protected
  def self.build_distance_matrix(distances:)
    distance_matrix = []
    distances.each do |distance_row|
      row_list = distance_row.map(&:distance_in_meters)
      distance_matrix.append(row_list)
    end

    distance_matrix
  end
end
