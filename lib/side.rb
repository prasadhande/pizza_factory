# Represents a Side item with its name and price.
class Side
  attr_reader :name, :price

  # Initializes a Side object.
  # @param name [String] The name of the side.
  # @param price [Integer] The price of the side.
  def initialize(name, price)
    if price <= 0  # Check for both zero and negative
      raise ArgumentError, "Price must be greater than zero"
    end
    @name = name
    @price = price
  end
end