# spec/pizza_factory/menu_spec.rb

require 'rspec'
require_relative '../../lib/pizza_factory/menu'

module PizzaFactory
  RSpec.describe Menu do
    let(:menu) { Menu.new }

    describe '#pizzas' do
      it 'returns all available pizzas' do
        expect(menu.pizzas).to include({ type: :vegetarian, name: :deluxe_veggie })
        expect(menu.pizzas).to include({ type: :non_vegetarian, name: :chicken_tikka })
      end
    end

    describe '#sides' do
      it 'returns all available sides' do
        expect(menu.sides).to include(:cold_drink)
      end
    end

    describe '#toppings' do
      it 'returns all available toppings' do
        expect(menu.toppings[:veg]).to include(:capsicum)
        expect(menu.toppings[:non_veg]).to include(:chicken_tikka)
      end
    end

    describe '#crusts' do
      it 'returns all available crusts' do
        expect(menu.crusts).to include(:new_hand_tossed)
      end
    end
  end
end
