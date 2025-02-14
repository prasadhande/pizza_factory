# lib/pizza_factory/inventory.rb

require_relative 'menu'

module PizzaFactory
  # The Inventory class manages the stock of ingredients.
  class Inventory
    def initialize
      # Initialize the inventory with an empty hash.
      @ingredients = Hash.new(0)
    end

    # Adds a specified quantity of an ingredient to the inventory.
    def add_ingredient(ingredient, quantity)
      @ingredients[ingredient] += quantity
    end

    # Uses a specified quantity of an ingredient from the inventory.
    def use_ingredient(ingredient, quantity)
      raise "Insufficient ingredients: #{ingredient}" if @ingredients[ingredient] < quantity

      @ingredients[ingredient] -= quantity
    end

    # Checks if there are sufficient ingredients for a given pizza.
    def sufficient_ingredients_for_pizza?(pizza)
      menu = Menu.new
      required_ingredients = []

      # Base pizza ingredient.
      required_ingredients << pizza.name

      # Crust.
      required_ingredients << pizza.crust

      # Toppings.
      pizza.toppings.each do |topping|
        required_ingredients << topping.name
      end

      # Extra cheese.
      required_ingredients << :extra_cheese if pizza.extra_cheese

      # Check if all required ingredients are available.
      required_ingredients.all? { |ingredient| @ingredients[ingredient] > 0 }
    end

    # Checks if there are sufficient ingredients for a given side.
    def sufficient_ingredients_for_side?(side)
      @ingredients[side.name] > 0
    end
  end
end
