# lib/pizza_factory/business_rules.rb

module PizzaFactory
  # The BusinessRules class contains all the business logic and validations for orders.
  class BusinessRules
    # Validates a pizza based on the business rules.
    def self.valid_pizza_order?(pizza)
      # Rule 1: Vegetarian pizza cannot have a non-vegetarian topping.
      if pizza.type == :vegetarian
        return false if pizza.toppings.any? { |topping| topping.category == :non_veg }
      end

      # Rule 2: Non-vegetarian pizza cannot have paneer topping.
      if pizza.type == :non_vegetarian
        return false if pizza.toppings.any? { |topping| topping.name == :paneer }
      end

      # Rule 3: Only one type of crust can be selected for any pizza.
      # (Handled in the Pizza class by design.)

      # Rule 4: Only one non-veg topping can be added to a non-vegetarian pizza.
      if pizza.type == :non_vegetarian
        non_veg_toppings_count = pizza.toppings.count { |topping| topping.category == :non_veg }
        return false if non_veg_toppings_count > 1
      end

      true
    end

    # Checks if the inventory has sufficient ingredients to fulfill the order.
    def self.can_fulfill_order?(order, inventory)
      # Check pizzas
      order.pizzas.all? { |pizza| inventory.sufficient_ingredients_for_pizza?(pizza) } &&
        # Check sides
        order.sides.all? { |side| inventory.sufficient_ingredients_for_side?(side) }
    end
  end
end
