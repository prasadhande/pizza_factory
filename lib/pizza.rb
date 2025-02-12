# Represents a Pizza with its name, prices by size, and vegetarian status.
class Pizza
  attr_reader :name, :price_by_size, :vegetarian

  # Initializes a Pizza object.
  # @param name [String] The name of the pizza.
  # @param price_by_size [Hash] A hash of prices keyed by size (e.g., {"Regular" => 150, "Medium" => 200}).
  # @param vegetarian [Boolean] Whether the pizza is vegetarian.
  def initialize(name, price_by_size, vegetarian)
    @name = name
    @price_by_size = price_by_size
    @vegetarian = vegetarian
  end

  # Returns the price of the pizza for a given size.
  # @param size [String] The size of the pizza (e.g., "Regular", "Medium").
  # @return [Integer] The price of the pizza.
  # @raise [RuntimeError] If the size is invalid.
  def price(size)
    @price_by_size[size] || raise("Invalid pizza size")
  end
end