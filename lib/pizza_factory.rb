# lib/pizza_factory.rb

require_relative 'pizza_factory/menu'
require_relative 'pizza_factory/inventory'
require_relative 'pizza_factory/order'
require_relative 'pizza_factory/pizza'
require_relative 'pizza_factory/side'
require_relative 'pizza_factory/topping'
require_relative 'pizza_factory/business_rules'
require_relative 'pizza_factory/cost'

module PizzaFactory
  # The main PizzaFactory class that coordinates between different components.
  class Service
    attr_reader :menu, :inventory

    def initialize
      @menu = Menu.new
      @inventory = Inventory.new
    end

    # Places an order if it is valid.
    def place_order(order)
      if order.valid_order?(@inventory)
        process_order(order)
        order.place_order
        "Order placed successfully! Your total is Rs. #{order.total_cost}."
      else
        "Order could not be placed due to invalid selections or insufficient inventory."
      end
    end

    # Restocks the inventory with a specified ingredient and quantity.
    def restock_inventory(ingredient, quantity)
      @inventory.add_ingredient(ingredient, quantity)
    end

    # Adds a new pizza to the menu.
    def add_new_pizza(type, name, prices)
      @menu.base_prices[type][name] = prices
    end

    # Adds a new topping to the menu.
    def add_new_topping(category, name, price)
      @menu.topping_prices[category][name] = price
    end

    # Adds a new side to the menu.
    def add_new_side(name, price)
      @menu.side_prices[name] = price
    end

    # Changes the price of an existing item.
    def change_price(item_type, item_name, new_price)
      case item_type
      when :pizza
        @menu.base_prices.each do |type, pizzas|
          if pizzas.key?(item_name)
            pizzas[item_name] = new_price
            return
          end
        end
      when :topping
        @menu.topping_prices.each do |category, toppings|
          if toppings.key?(item_name)
            toppings[item_name] = new_price
            return
          end
        end
      when :side
        @menu.side_prices[item_name] = new_price
      end
    end

    private

    # Processes the order by deducting ingredients from the inventory.
    def process_order(order)
      order.pizzas.each do |pizza|
        @inventory.use_ingredient(pizza.name, 1)
        @inventory.use_ingredient(pizza.crust, 1)
        pizza.toppings.each { |topping| @inventory.use_ingredient(topping.name, 1) }
        @inventory.use_ingredient(:extra_cheese, 1) if pizza.extra_cheese
      end
      order.sides.each { |side| @inventory.use_ingredient(side.name, 1) }
    end
  end
end
