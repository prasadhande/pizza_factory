# spec/pizza_factory/cost_spec.rb

require 'rspec'
require_relative '../../lib/pizza_factory/cost'
require_relative '../../lib/pizza_factory/pizza'
require_relative '../../lib/pizza_factory/topping'
require_relative '../../lib/pizza_factory/side'

module PizzaFactory
  RSpec.describe Cost do
    let(:pizza) { Pizza.new(:vegetarian, :deluxe_veggie, :regular, :new_hand_tossed) }
    let(:side) { Side.new(:cold_drink) }

    before do
      pizza.add_topping(Topping.new(:veg, :capsicum))
      pizza.add_topping(Topping.new(:veg, :mushroom))
      pizza.extra_cheese = true
    end

    describe '.calculate_pizza_cost' do
      it 'calculates the cost of a pizza with toppings and extra cheese' do
        expect(Cost.calculate_pizza_cost(pizza)).to eq(150 + 25 + 30 + 35)
      end

      context 'when pizza is large size with two toppings' do
        let(:large_pizza) { Pizza.new(:vegetarian, :deluxe_veggie, :large, :new_hand_tossed) }

        before do
          large_pizza.add_topping(Topping.new(:veg, :capsicum))
          large_pizza.add_topping(Topping.new(:veg, :mushroom))
        end

        it 'does not charge for the first two toppings' do
          expect(Cost.calculate_pizza_cost(large_pizza)).to eq(325)
        end
      end

      context 'when pizza is large size with more than two toppings' do
        let(:large_pizza) { Pizza.new(:vegetarian, :deluxe_veggie, :large, :new_hand_tossed) }

        before do
          large_pizza.add_topping(Topping.new(:veg, :capsicum))
          large_pizza.add_topping(Topping.new(:veg, :mushroom))
          large_pizza.add_topping(Topping.new(:veg, :paneer)) # Additional topping
        end

        it 'charges for extra toppings beyond the first two' do
          expect(Cost.calculate_pizza_cost(large_pizza)).to eq(325 + 35) # Base price + paneer topping
        end
      end
    end

    describe '.calculate_side_cost' do
      it 'calculates the cost of a side' do
        expect(Cost.calculate_side_cost(side)).to eq(55)
      end
    end
  end
end
