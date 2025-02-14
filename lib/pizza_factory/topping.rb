# lib/pizza_factory/topping.rb

module PizzaFactory
  # The Topping class represents a topping that can be added to a pizza.
  class Topping
    attr_reader :category, :name

    # Initializes a new topping with a category and name.
    def initialize(category, name)
      @category = category # :veg or :non_veg
      @name = name # e.g., :capsicum
    end
  end
end
