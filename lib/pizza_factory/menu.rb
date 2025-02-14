# lib/pizza_factory/menu.rb

module PizzaFactory
  # The Menu class contains all available pizzas, toppings, crusts, and sides with their prices.
  class Menu
    attr_reader :base_prices, :topping_prices, :side_prices, :crusts, :extra_cheese_price

    def initialize
      @base_prices = {
        vegetarian: {
          deluxe_veggie: { regular: 150, medium: 200, large: 325 },
          cheese_and_corn: { regular: 175, medium: 375, large: 475 },
          paneer_tikka: { regular: 160, medium: 290, large: 340 }
        },
        non_vegetarian: {
          non_veg_supreme: { regular: 190, medium: 325, large: 425 },
          chicken_tikka: { regular: 210, medium: 370, large: 500 },
          pepper_barbecue_chicken: { regular: 220, medium: 380, large: 525 }
        }
      }

      @topping_prices = {
        veg: {
          black_olive: 20,
          capsicum: 25,
          paneer: 35,
          mushroom: 30,
          fresh_tomato: 10
        },
        non_veg: {
          chicken_tikka: 35,
          barbeque_chicken: 45,
          grilled_chicken: 40
        }
      }

      @extra_cheese_price = 35

      @side_prices = {
        cold_drink: 55,
        mousse_cake: 90
      }

      @crusts = [:new_hand_tossed, :wheat_thin_crust, :cheese_burst, :fresh_pan_pizza]
    end

    # Returns all available pizzas as an array of hashes.
    def pizzas
      vegetarian_pizzas = @base_prices[:vegetarian].keys.map do |name|
        { type: :vegetarian, name: name }
      end

      non_vegetarian_pizzas = @base_prices[:non_vegetarian].keys.map do |name|
        { type: :non_vegetarian, name: name }
      end

      vegetarian_pizzas + non_vegetarian_pizzas
    end

    # Returns all available sides.
    def sides
      @side_prices.keys
    end

    # Returns all available toppings.
    def toppings
      @topping_prices
    end
  end
end
