# lib/pizza_factory/cost.rb

require_relative 'menu'

module PizzaFactory
  # The Cost class handles all price calculations for pizzas, toppings, and sides.
  class Cost
    # Calculates the total cost of a pizza including base price, crust (if any additional cost), and toppings.
    def self.calculate_pizza_cost(pizza)
      menu = Menu.new

      # Fetch the base price of the pizza based on type, name, and size.
      base_price = menu.base_prices[pizza.type][pizza.name][pizza.size]

      # Calculate any additional cost for the crust (assuming crusts have no extra cost in this case).
      crust_cost = 0

      # Calculate the cost of toppings, considering business rules.
      topping_cost = calculate_topping_cost(pizza)

      # Sum up the total cost.
      total_cost = base_price + crust_cost + topping_cost
      total_cost
    end

    # Calculates the total cost of the toppings on a pizza, applying any special business rules.
    def self.calculate_topping_cost(pizza)
      menu = Menu.new

      # For large pizzas, the first two toppings are free.
      if pizza.size == :large
        paid_toppings = pizza.toppings.drop(2)
      else
        paid_toppings = pizza.toppings
      end

      # Sum up the cost of the paid toppings.
      topping_cost = paid_toppings.map do |topping|
        # Fetch the price of each topping based on its type and name.
        menu.topping_prices[topping.category][topping.name]
      end.sum

      # Add cost for extra cheese if selected.
      if pizza.extra_cheese
        topping_cost += menu.extra_cheese_price
      end

      topping_cost
    end

    # Calculates the cost of a side item.
    def self.calculate_side_cost(side)
      menu = Menu.new
      menu.side_prices[side.name]
    end
  end
end
