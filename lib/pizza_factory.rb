require_relative 'pizza'
require_relative 'topping'
require_relative 'crust'
require_relative 'side'
require_relative 'order'
require_relative 'order_item'
require_relative 'side_item'

# Manages the pizza ordering process, including menu, inventory, and order creation.
class PizzaFactory
  attr_reader :menu, :toppings, :crusts, :sides, :inventory

  # Initializes a PizzaFactory object.
  def initialize
    @menu = {} # Hash of pizza names to Pizza objects.
    @toppings = {} # Hash of topping names to Topping objects.
    @crusts = {} # Hash of crust names to Crust objects.
    @sides = {} # Hash of side names to Side objects.
    @inventory = {} # Hash of ingredient names to quantities.
  end

  # Adds a pizza to the menu.
  # @param pizza [Pizza] The pizza to add.
  def add_pizza(pizza)
    @menu[pizza.name] = pizza
  end

  # Adds a topping to the list of available toppings.
  # @param topping [Topping] The topping to add.
  def add_topping(topping)
    @toppings[topping.name] = topping
  end

  # Adds a crust to the list of available crusts.
  # @param crust [Crust] The crust to add.
  def add_crust(crust)
    @crusts[crust.name] = crust
  end

  # Adds a side to the list of available sides.
  # @param side [Side] The side to add.
  def add_side(side)
    @sides[side.name] = side
  end

  # Restocks the inventory for a given ingredient.
  # @param ingredient
    # @param ingredient [String] The ingredient to restock.
  # @param quantity [Integer] The quantity to restock.
  def restock_inventory(ingredient, quantity)
    @inventory[ingredient] ||= 0 # Initialize to 0 if not present
    @inventory[ingredient] += quantity
  end

  # Checks if there is sufficient inventory for all toppings in the order.
  # @param order [Order] The order to check the inventory for.
  # @raise [RuntimeError] If there is insufficient inventory for any topping.
  def check_inventory(order)
    order.order_items.each do |item|
      item.toppings.each do |topping|
        raise "Insufficient inventory for #{topping.name}" unless @inventory[topping.name] && @inventory[topping.name] > 0
      end
    end
  end

  # Creates an order.
  # @param items [Array<Hash>] An array of hashes, each representing an order item.
  #   Each hash should have keys :pizza (String), :size (String), :crust (String), and optionally :toppings (Array<String>).
  # @param side_items [Array<Hash>] An array of hashes, each representing a side item.
  #   Each hash should have keys :side (String) and optionally :quantity (Integer).
  # @return [Order] The created order object.
  # @raise [RuntimeError] If any input is invalid or business rules are violated.
  def create_order(items, side_items = [])

    raise TypeError, "items must be an array" unless items.is_a?(Array)
    raise TypeError, "side_items must be an array" unless side_items.is_a?(Array)

    order = Order.new

    items.each do |item_data|
      pizza_name = item_data[:pizza]
      pizza = @menu[pizza_name] || raise("Invalid pizza name: #{pizza_name}")

      size = item_data[:size] || raise("Size is required") # Size is now mandatory

      crust_name = item_data[:crust]
      crust = @crusts[crust_name] || raise("Invalid crust name: #{crust_name}")

      topping_names = item_data[:toppings] || []
      toppings = topping_names.map do |topping_name|
        @toppings[topping_name] || raise("Invalid topping name: #{topping_name}")
      end

      # Large pizza logic (two free toppings)
      if size == "Large" && toppings.length > 2
        toppings = toppings[0..1] # Keep only the first two (free)
      end

      order_item = OrderItem.new(pizza, size, crust, toppings)
      order.add_item(order_item)
    end

    side_items.each do |side_data|
      side_name = side_data[:side]
      side = @sides[side_name] || raise("Invalid side name: #{side_name}")
      quantity = side_data[:quantity] || 1 # Default quantity to 1
      side_item = SideItem.new(side, quantity)
      order.add_side_item(side_item)
    end

    check_inventory(order)
    order.validate
    order
  end
end