require_relative '../../lib/shortest_route_solver/addresses_geocoder'
require_relative '../../lib/shortest_route_solver/distance_matrix_calculator'
require_relative '../../lib/shortest_route_solver/shortest_route_solver'
require_relative '../../lib/shortest_route_solver/shortest_route_solution_extractor'

class ShortestRouteController < ApplicationController
  def get
    geolocations =
      ShortestRouteController.get_geolocations_from_address_params(address_params)

    geocode_failed =
      ShortestRouteController.geocode_failed?(geolocations)

    if geocode_failed
      errored_address_indices = geolocations.each_with_index.inject([]) do |collected_indices, (geolocation, index)|
        if geolocation.nil?
          collected_indices << index
        end

        collected_indices
      end

      error_response = {
        :erroredAddressIndices => errored_address_indices,
        :message => 'One or more addresses could not be found.'
      }

      return render :json => error_response,
                    :status => :bad_request
    end

    shortest_route_order =
      ShortestRouteController.get_shortest_route_order_from_geolocations(geolocations)

    render json: {
             :geolocations => geolocations,
             :order => shortest_route_order
           }
  end

  protected
  def self.get_geolocations_from_address_params(address_params)
    addresses = address_params.split('|')
    AddressesGeocoder.geocode(addresses)
  end

  protected
  def self.geocode_failed?(geolocations)
    geolocations.any? &:nil?
  end

  protected
  def self.get_shortest_route_order_from_geolocations(geolocations)
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
