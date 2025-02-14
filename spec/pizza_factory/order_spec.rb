# spec/pizza_factory/order_spec.rb

require 'rspec'
require_relative '../../lib/pizza_factory/order'
require_relative '../../lib/pizza_factory/pizza'
require_relative '../../lib/pizza_factory/side'
require_relative '../../lib/pizza_factory/topping'
require_relative '../../lib/pizza_factory/cost'
require_relative '../../lib/pizza_factory/inventory'
require_relative '../../lib/pizza_factory/business_rules'
require_relative '../../lib/pizza_factory/menu'

module PizzaFactory
  RSpec.describe Order do
    let(:order) { Order.new }
    let(:pizza) { Pizza.new(:vegetarian, :deluxe_veggie, :regular, :new_hand_tossed) }
    let(:side) { Side.new(:cold_drink) }
    let(:inventory) { Inventory.new }
    let(:menu) { Menu.new }

    before do
      pizza.add_topping(Topping.new(:veg, :capsicum))
      pizza.add_topping(Topping.new(:veg, :mushroom))
      pizza.extra_cheese = true

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

    describe '#add_pizza' do
      context 'when order is new' do
        it 'adds a pizza to the order' do
          order.add_pizza(pizza)
          expect(order.pizzas).to include(pizza)
        end
      end

      context 'when order is placed' do
        it 'does not add a pizza to the order' do
          order.place_order
          order.add_pizza(pizza)
          expect(order.pizzas).to be_empty
        end
      end
    end

    describe '#add_side' do
      context 'when order is new' do
        it 'adds a side to the order' do
          order.add_side(side)
          expect(order.sides).to include(side)
        end
      end

      context 'when order is placed' do
        it 'does not add a side to the order' do
          order.place_order
          order.add_side(side)
          expect(order.sides).to be_empty
        end
      end
    end

    describe '#place_order' do
      it 'changes status to placed' do
        order.place_order
        expect(order.status).to eq(:placed)
      end

      it 'prevents further modifications' do
        order.place_order
        expect(order.add_pizza(pizza)).to be_nil
      end
    end

    describe '#total_cost' do
      it 'calculates the total cost of the order' do
        order.add_pizza(pizza)
        order.add_side(side)
        expect(order.total_cost).to eq(150 + 25 + 30 + 35 + 55)
      end
    end

    describe '#valid_order?' do
      it 'returns true for a valid order' do
        order.add_pizza(pizza)
        order.add_side(side)
        expect(order.valid_order?(inventory)).to be_truthy
      end

      it 'returns false if any business rule is violated' do
        invalid_pizza = Pizza.new(:vegetarian, :deluxe_veggie, :regular, :new_hand_tossed)
        invalid_pizza.add_topping(Topping.new(:non_veg, :chicken_tikka))
        order.add_pizza(invalid_pizza)
        expect(order.valid_order?(inventory)).to be_falsey
      end

      it 'returns false if inventory cannot fulfill the order' do
        inventory.use_ingredient(:capsicum, 5) # Deplete capsicum
        order.add_pizza(pizza)
        expect(order.valid_order?(inventory)).to be_falsey
      end
    end
  end
end
