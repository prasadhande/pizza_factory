# Represents a Topping with its name, price, and vegetarian status.
class Topping
  attr_reader :name, :price, :vegetarian

  # Initializes a Topping object.
  # @param name [String] The name of the topping.
  # @param price [Integer] The price of the topping.
  # @param vegetarian [Boolean] Whether the topping is vegetarian.
  # @raise [ArgumentError] If the price is negative.
  def initialize(name, price, vegetarian)
    if price.negative?
      raise ArgumentError.new("Price cannot be negative") # Correct way to raise ArgumentError
    end
    @name = name
    @price = price
    @vegetarian = vegetarian
  end
end