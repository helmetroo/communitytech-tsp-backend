require 'or-tools'

class ShortestRouteSolver
  def initialize(distance_matrix:)
    @distance_matrix = distance_matrix
    self.initialize_solver_components
  end

  protected
  def initialize_solver_components
    # Assumes ONE vehicle (TSP), start where you end (depot = 0)
    @routing_index_manager =
      ORTools::RoutingIndexManager.new(@distance_matrix.length, 1, 0)
    @routing_model = ORTools::RoutingModel.new(routing_index_manager)
    @solution = nil
  end

  public
  def routing_index_manager
    @routing_index_manager
  end

  public
  def routing_model
    @routing_model
  end

  public
  def solution
    @solution
  end

  public
  def solved?
    # TODO not correct way to check apparently
    @solution.nil?
  end

  public
  def solve
    transit_callback = self.create_transit_callback(@routing_index_manager)
    transit_callback_index = @routing_model.register_transit_callback(transit_callback)
    @routing_model.set_arc_cost_evaluator_of_all_vehicles(transit_callback_index)
    @solution = @routing_model.solve(first_solution_strategy: :path_cheapest_arc)
  end

  protected
  def create_transit_callback(routing_index_manager)
    lambda do |from_index, to_index|
      from_node = routing_index_manager.index_to_node(from_index)
      to_node = routing_index_manager.index_to_node(to_index)
      @distance_matrix[from_node][to_node]
    end
  end
end
