class ShortestRouteSolutionExtractor
  def initialize(shortest_route_solver:)
    @shortest_route_solver = shortest_route_solver
  end

  public
  def print
    solution = @shortest_route_solver.solution
    routing_index_manager = @shortest_route_solver.routing_index_manager
    routing_model = @shortest_route_solver.routing_model

    puts "Objective: #{solution.objective_value} meters"
    index = routing_model.start(0)
    plan_output = String.new("Route for vehicle 0:\n")
    route_distance = 0
    while !routing_model.end?(index)
      plan_output += " #{routing_index_manager.index_to_node(index)} ->"
      previous_index = index
      index = solution.value(routing_model.next_var(index))
      route_distance += routing_model.arc_cost_for_vehicle(previous_index, index, 0)
    end
    plan_output += " #{routing_index_manager.index_to_node(index)}\n"
    puts plan_output
  end

  public
  def extract
    solution = @shortest_route_solver.solution
    routing_index_manager = @shortest_route_solver.routing_index_manager
    routing_model = @shortest_route_solver.routing_model

    index = routing_model.start(0)
    order = []
    while !routing_model.end?(index)
      order << routing_index_manager.index_to_node(index)
      index = solution.value(routing_model.next_var(index))
    end

    order
  end
end
