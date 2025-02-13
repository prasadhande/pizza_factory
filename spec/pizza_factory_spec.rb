require 'rspec'
require_relative '../lib/pizza_factory'

RSpec.describe PizzaFactory do
  let(:factory) { PizzaFactory.new }
  let(:deluxe_veggie) { Pizza.new("Deluxe Veggie", { "Regular" => 150, "Medium" => 200, "Large" => 325 }, true) }
  let(:non_veg_supreme) { Pizza.new("Non-Veg Supreme", { "Regular" => 190, "Medium" => 325, "Large" => 425 }, false) }
  let(:olive) { Topping.new("Black olive", 20, true) }
  let(:capsicum) { Topping.new("Capsicum", 25, true) }
  let(:paneer) { Topping.new("Paneer", 35, true) }
  let(:chicken_tikka_topping) { Topping.new("Chicken tikka", 35, false) }
  let(:bbq_chicken_topping) { Topping.new("Barbeque chicken", 45, false) }
  let(:hand_tossed) { Crust.new("New hand tossed") }
  let(:coke) { Side.new("Cold drink", 55) }

  before do
    factory.add_pizza(deluxe_veggie)
    factory.add_pizza(non_veg_supreme)
    factory.add_topping(olive)
    factory.add_topping(capsicum)
    factory.add_topping(paneer)
    factory.add_topping(chicken_tikka_topping)
    factory.add_topping(bbq_chicken_topping)
    factory.add_crust(hand_tossed)
    factory.add_side(coke)
    factory.restock_inventory("Black olive", 5)
    factory.restock_inventory("Capsicum", 5)
    factory.restock_inventory("Paneer", 5)
    factory.restock_inventory("Chicken tikka", 5)
    factory.restock_inventory("Barbeque chicken", 5)
  end


end