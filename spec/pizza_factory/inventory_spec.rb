# spec/pizza_factory/inventory_spec.rb

require 'rspec'
require_relative '../../lib/pizza_factory/inventory'
require_relative '../../lib/pizza_factory/pizza'
require_relative '../../lib/pizza_factory/side'
require_relative '../../lib/pizza_factory/topping'
require_relative '../../lib/pizza_factory/menu'

module PizzaFactory
  RSpec.describe Inventory do
    let(:inventory) { Inventory.new }
    let(:menu) { Menu.new }
    let(:veg_pizza) { Pizza.new(:vegetarian, :deluxe_veggie, :regular, :new_hand_tossed) }
    let(:side) { Side.new(:cold_drink) }

    before do
      veg_pizza.add_topping(Topping.new(:veg, :capsicum))
      veg_pizza.add_topping(Topping.new(:veg, :mushroom))
      veg_pizza.extra_cheese = true

      # Add ingredients to inventory
      menu.base_prices.each do |_type, pizzas|
        pizzas.keys.each { |pizza_name| inventory.add_ingredient(pizza_name, 5) }
      end
      menu.crusts.each { |crust| inventory.add_ingredient(crust, 5) }
      menu.topping_prices.each do |_category, toppings|
        toppings.keys.each { |topping_name| inventory.add_ingredient(topping_name, 5) }
      end
      menu.side_prices.keys.each { |side_name| inventory.add_ingredient(side_name, 5) }
      inventory.add_ingredient(:extra_cheese, 5)
    end

    describe '#sufficient_ingredients_for_pizza?' do
      it 'returns true if inventory has enough ingredients' do
        expect(inventory.sufficient_ingredients_for_pizza?(veg_pizza)).to be_truthy
      end

      it 'returns false if any ingredient is insufficient' do
        inventory.use_ingredient(:capsicum, 5) # Deplete capsicum
        expect(inventory.sufficient_ingredients_for_pizza?(veg_pizza)).to be_falsey
      end
    end

    describe '#sufficient_ingredients_for_side?' do
      it 'returns true if inventory has enough of the side' do
        expect(inventory.sufficient_ingredients_for_side?(side)).to be_truthy
      end

      it 'returns false if the side is insufficient' do
        inventory.use_ingredient(:cold_drink, 5) # Deplete cold drink
        expect(inventory.sufficient_ingredients_for_side?(side)).to be_falsey
      end
    end

    describe '#use_ingredient' do
      it 'decreases the ingredient quantity' do
        inventory.use_ingredient(:capsicum, 1)
        expect(inventory.instance_variable_get(:@ingredients)[:capsicum]).to eq(4)
      end

      it 'raises an error if insufficient ingredients' do
        expect { inventory.use_ingredient(:capsicum, 6) }.to raise_error("Insufficient ingredients: capsicum")
      end
    end
  end
end
