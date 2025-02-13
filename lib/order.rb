require_relative 'order_rule'
require_relative 'order_rules/no_order_cancellation_rule' 

# Represents an order with order items and side items.
class Order
  attr_reader :order_items, :side_items

  def initialize
    @order_items = []
    @side_items = []
    @rules = [
      VegetarianPizzaNonVegToppingRule.new,
      NonVegPizzaNoPaneerRule.new,
      OnlyOneNonVegToppingRule.new,
      LargePizzaTwoFreeToppingsRule.new,
      NoOrderCancellationRule.new
    ] # Initialize rules
  end

  # Adds an order item to the order.
  # @param order_item [OrderItem] The order item to add.
  # @raise [TypeError] If the order_item is not an OrderItem object.
  def add_item(order_item)
    raise TypeError, "order_item must be an OrderItem" unless order_item.is_a?(OrderItem)
    @order_items << order_item
  end

  # Adds a side item to the order.
  # @param side_item [SideItem] The side item to add.
  # @raise [TypeError] If the side_item is not a SideItem object.
  def add_side_item(side_item)
    raise TypeError, "side_item must be a SideItem" unless side_item.is_a?(SideItem)
    @side_items << side_item
  end

  # Calculates the total price of the order.
  # @return [Integer] The total price.
  def total_price
    items_total = @order_items.sum(&:price) || 0 # Handle empty order_items
    sides_total = @side_items.sum(&:price) || 0 # Handle empty side_items
    items_total + sides_total
  end

  # Validates the order against defined rules.
  # @raise [RuntimeError] If any of the rules are violated.
  def validate
    @order_items.each do |order_item|
      @rules.each do |rule| # Apply each rule
        rule.validate(order_item) if rule.applies?(order_item)
      end
    end
  end
end