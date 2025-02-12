# Represents a side item in the order with its side and quantity.
class SideItem
  attr_reader :side, :quantity

  # Initializes a SideItem object.
  # @param side [Side] The Side object.
  # @param quantity [Integer] The quantity of the side.
  # @raise [ArgumentError] If the quantity is negative.
  def initialize(side, quantity)
    if quantity.negative? # Check the condition *first*
      raise ArgumentError, "Quantity cannot be negative" 
    end
    @side = side
    @quantity = quantity
  end

  # Calculates the price of the side item.
  # @return [Integer] The price of the side item.
  def price
    @side.price * @quantity
  end
end