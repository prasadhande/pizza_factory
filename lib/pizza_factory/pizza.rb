# lib/pizza_factory/pizza.rb

require_relative 'topping'

module PizzaFactory
  # The Pizza class represents a pizza and its customizable attributes.
  class Pizza
    attr_reader :type, :name, :size, :crust, :toppings
    attr_accessor :extra_cheese

    # Initializes a new pizza with type, name, size, and crust.
    def initialize(type, name, size, crust)
      @type = type # :vegetarian or :non_vegetarian
      @name = name # e.g., :deluxe_veggie
      @size = size # :regular, :medium, or :large
      @crust = crust # e.g., :new_hand_tossed
      @toppings = []
      @extra_cheese = false
    end

    # Adds a topping to the pizza.
    def add_topping(topping)
      @toppings << topping
    end
  end
end
