# lib/order_item.rb
# Represents an item in the order, consisting of a pizza, size, crust, and toppings.
class OrderItem
  attr_reader :pizza, :size, :crust, :toppings

  # Initializes an OrderItem object.
  # @param pizza [Pizza] The pizza object.
  # @param size [String] The size of the pizza.
  # @param crust [Crust] The crust object.
  # @param toppings [Array<Topping>] An array of topping objects.
  def initialize(pizza, size, crust, toppings = [])
    @pizza = pizza
    @size = size
    @crust = crust
    @toppings = toppings
  end

  # Calculates the price of the order item (excluding Large pizza free toppings).
  # @return [Integer] The price of the order item.
  def price
    base_price = @pizza&.price(@size) || 0  # Correct: Safe navigation on @pizza
    topping_price = @pizza ? @toppings.sum(&:price) : 0 # Correct topping logic
    base_price + topping_price
  end
end