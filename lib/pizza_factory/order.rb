# lib/pizza_factory/order.rb

require_relative 'business_rules'
require_relative 'cost'

module PizzaFactory
  # The Order class represents a customer's order and manages its state.
  class Order
    attr_reader :pizzas, :sides, :status

    def initialize
      @pizzas = []
      @sides = []
      @status = :new # Possible statuses: :new, :placed
    end

    # Adds a pizza to the order if the order is still new.
    def add_pizza(pizza)
      @pizzas << pizza if @status == :new
    end

    # Adds a side to the order if the order is still new.
    def add_side(side)
      @sides << side if @status == :new
    end

    # Places the order, changing its status to :placed.
    def place_order
      @status = :placed
    end

    # Calculates the total cost of the order.
    def total_cost
      pizza_costs = @pizzas.map { |pizza| Cost.calculate_pizza_cost(pizza) }
      side_costs = @sides.map { |side| Cost.calculate_side_cost(side) }
      pizza_costs.sum + side_costs.sum
    end

    # Validates the order based on business rules and inventory.
    def valid_order?(inventory)
      # Check if all pizzas in the order are valid per business rules.
      all_pizzas_valid = @pizzas.all? { |pizza| BusinessRules.valid_pizza_order?(pizza) }

      # Check if there is sufficient inventory to fulfill the order.
      inventory_can_fulfill = BusinessRules.can_fulfill_order?(self, inventory)

      all_pizzas_valid && inventory_can_fulfill
    end
  end
end
