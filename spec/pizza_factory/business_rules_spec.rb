# spec/pizza_factory/business_rules_spec.rb

require 'rspec'
require_relative '../../lib/pizza_factory/business_rules'
require_relative '../../lib/pizza_factory/pizza'
require_relative '../../lib/pizza_factory/topping'
require_relative '../../lib/pizza_factory/order'
require_relative '../../lib/pizza_factory/inventory'

module PizzaFactory
  RSpec.describe BusinessRules do
    let(:menu) { Menu.new }
    let(:inventory) { Inventory.new }
    let(:veg_pizza) { Pizza.new(:vegetarian, :deluxe_veggie, :regular, :new_hand_tossed) }
    let(:non_veg_pizza) { Pizza.new(:non_vegetarian, :non_veg_supreme, :regular, :new_hand_tossed) }

    before do
      # Add basic ingredients to inventory
      menu.base_prices.each do |_type, pizzas|
        pizzas.keys.each { |pizza_name| inventory.add_ingredient(pizza_name, 5) }
      end
      menu.crusts.each { |crust| inventory.add_ingredient(crust, 5) }
      menu.topping_prices.each do |_category, toppings|
        toppings.keys.each { |topping_name| inventory.add_ingredient(topping_name, 5) }
      end
      inventory.add_ingredient(:extra_cheese, 5)
    end

    describe '.valid_pizza_order?' do
      context 'when a vegetarian pizza has a non-veg topping' do
        before { veg_pizza.add_topping(Topping.new(:non_veg, :chicken_tikka)) }

        it 'returns false' do
          expect(BusinessRules.valid_pizza_order?(veg_pizza)).to be_falsey
        end
      end

      context 'when a non-vegetarian pizza has a paneer topping' do
        before { non_veg_pizza.add_topping(Topping.new(:veg, :paneer)) }

        it 'returns false' do
          expect(BusinessRules.valid_pizza_order?(non_veg_pizza)).to be_falsey
        end
      end

      context 'when a non-vegetarian pizza has more than one non-veg topping' do
        before do
          non_veg_pizza.add_topping(Topping.new(:non_veg, :chicken_tikka))
          non_veg_pizza.add_topping(Topping.new(:non_veg, :barbeque_chicken))
        end

        it 'returns false' do
          expect(BusinessRules.valid_pizza_order?(non_veg_pizza)).to be_falsey
        end
      end

      context 'when a large pizza has multiple toppings' do
        let(:large_pizza) { Pizza.new(:vegetarian, :deluxe_veggie, :large, :new_hand_tossed) }

        before do
          large_pizza.add_topping(Topping.new(:veg, :capsicum))
          large_pizza.add_topping(Topping.new(:veg, :mushroom))
          large_pizza.add_topping(Topping.new(:veg, :fresh_tomato))
        end

        it 'considers the pizza order valid' do
          expect(BusinessRules.valid_pizza_order?(large_pizza)).to be_truthy
        end
      end
    end

    describe '.can_fulfill_order?' do
      let(:order) { Order.new }

      before do
        veg_pizza.add_topping(Topping.new(:veg, :capsicum))
        veg_pizza.add_topping(Topping.new(:veg, :mushroom))
        order.add_pizza(veg_pizza)
        order.add_side(Side.new(:cold_drink))
        inventory.add_ingredient(:cold_drink, 5)
      end

      it 'returns true if inventory can fulfill the order' do
        expect(BusinessRules.can_fulfill_order?(order, inventory)).to be_truthy
      end

      it 'returns false if inventory cannot fulfill the order' do
        inventory.use_ingredient(:capsicum, 5) # Deplete capsicum
        expect(BusinessRules.can_fulfill_order?(order, inventory)).to be_falsey
      end
    end
  end
end
