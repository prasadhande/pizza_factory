# lib/pizza_factory/side.rb

module PizzaFactory
  # The Side class represents a side item that can be ordered alongside pizzas.
  class Side
    attr_reader :name

    # Initializes a new side with a given name.
    def initialize(name)
      @name = name # e.g., :cold_drink
    end
  end
end
