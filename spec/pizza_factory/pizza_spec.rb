# spec/pizza_factory/pizza_spec.rb

require 'rspec'
require_relative '../../lib/pizza_factory/pizza'
require_relative '../../lib/pizza_factory/topping'

module PizzaFactory
  RSpec.describe Pizza do
    let(:pizza) { Pizza.new(:vegetarian, :deluxe_veggie, :regular, :new_hand_tossed) }

    describe '#initialize' do
      it 'creates a pizza with specified attributes' do
        expect(pizza.type).to eq(:vegetarian)
        expect(pizza.name).to eq(:deluxe_veggie)
        expect(pizza.size).to eq(:regular)
        expect(pizza.crust).to eq(:new_hand_tossed)
        expect(pizza.toppings).to be_empty
        expect(pizza.extra_cheese).to be_falsey
      end
    end

    describe '#add_topping' do
      let(:topping) { Topping.new(:veg, :capsicum) }

      it 'adds a topping to the pizza' do
        pizza.add_topping(topping)
        expect(pizza.toppings).to include(topping)
      end
    end

    describe '#extra_cheese=' do
      it 'sets the extra_cheese attribute' do
        pizza.extra_cheese = true
        expect(pizza.extra_cheese).to be_truthy
      end
    end
  end
end
