require 'geocoder'

require_relative '../../lib/shortest_route_solver/geolocation'
require_relative '../../lib/shortest_route_solver/distance_matrix_calculator'
require_relative '../../lib/shortest_route_solver/shortest_route_solver'
require_relative '../../lib/shortest_route_solver/shortest_route_solution_extractor'

class ShortestRouteController < ApplicationController
  def get
    shortest_route_order =
      ShortestRouteController
        .get_shortest_route_order_from_address_params(address_params)

    render json: {
             :order => shortest_route_order
           }
  end

  protected
  def self.get_shortest_route_order_from_address_params(address_params)
    addresses = address_params.split('|')
    geolocations = addresses.map do |address|
      geolocation = Geocoder.search(address).first
      Geolocation.new(latitude: geolocation.latitude, longitude: geolocation.longitude)
    end

    origin, *destinations = geolocations
    ShortestRouteController
      .get_shortest_route_order_from_origin_and_destinations(origin: origin, destinations: destinations)
  end

  protected
  def self.get_shortest_route_order_from_origin_and_destinations(origin: Geolocation.new(), destinations: [])
    distance_matrix = DistanceMatrixCalculator.calculate(origin: origin, destinations: destinations)

    solver = ShortestRouteSolver.new(distance_matrix: distance_matrix)
    solver.solve

    solution_extractor = ShortestRouteSolutionExtractor.new(shortest_route_solver: solver)
    solution_extractor.extract
  end

  private
  def address_params
    params.require(:addresses)
  end
end
