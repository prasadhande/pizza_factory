# spec/pizza_factory/service_spec.rb

require 'rspec'
require_relative '../../lib/pizza_factory'
require_relative '../../lib/pizza_factory/order'
require_relative '../../lib/pizza_factory/pizza'
require_relative '../../lib/pizza_factory/topping'
require_relative '../../lib/pizza_factory/side'

module PizzaFactory
  RSpec.describe Service do
    let(:service) { Service.new }
    let(:order) { Order.new }
    let(:pizza) { Pizza.new(:vegetarian, :deluxe_veggie, :regular, :new_hand_tossed) }
    let(:side) { Side.new(:cold_drink) }

    before do
      # Restock inventory with basic ingredients
      service.restock_inventory(:deluxe_veggie, 10)
      service.restock_inventory(:new_hand_tossed, 10)
      service.restock_inventory(:capsicum, 10)
      service.restock_inventory(:mushroom, 10)
      service.restock_inventory(:extra_cheese, 10)
      service.restock_inventory(:cold_drink, 10)
    end

    describe '#restock_inventory' do
      it 'increases the inventory of the specified ingredient' do
        service.restock_inventory(:capsicum, 5)
        inventory = service.inventory.instance_variable_get(:@ingredients)
        expect(inventory[:capsicum]).to eq(15) # 10 initial + 5 restocked
      end

      it 'adds a new ingredient to the inventory if not already present' do
        service.restock_inventory(:black_olive, 10)
        inventory = service.inventory.instance_variable_get(:@ingredients)
        expect(inventory[:black_olive]).to eq(10)
      end
    end

    describe '#place_order' do
      before do
        pizza.add_topping(Topping.new(:veg, :capsicum))
        pizza.add_topping(Topping.new(:veg, :mushroom))
        pizza.extra_cheese = true
        order.add_pizza(pizza)
        order.add_side(side)
      end

      context 'when the order is valid' do
        it 'places the order successfully' do
          message = service.place_order(order)
          expect(message).to eq("Order placed successfully! Your total is Rs. 295.") # 150 (base) + 25 (capsicum) + 30 (mushroom) + 35 (extra cheese) + 55 (side)
        end

        it 'reduces the inventory accordingly' do
          service.place_order(order)
          inventory = service.inventory.instance_variable_get(:@ingredients)
          expect(inventory[:deluxe_veggie]).to eq(9)
          expect(inventory[:new_hand_tossed]).to eq(9)
          expect(inventory[:capsicum]).to eq(9)
          expect(inventory[:mushroom]).to eq(9)
          expect(inventory[:extra_cheese]).to eq(9)
          expect(inventory[:cold_drink]).to eq(9)
        end
      end

      context 'when the order is invalid' do
        it 'does not place the order and returns an error message' do
          invalid_pizza = Pizza.new(:vegetarian, :deluxe_veggie, :regular, :new_hand_tossed)
          invalid_pizza.add_topping(Topping.new(:non_veg, :chicken_tikka))
          order.add_pizza(invalid_pizza)

          message = service.place_order(order)
          expect(message).to eq("Order could not be placed due to invalid selections or insufficient inventory.")
        end
      end
    end

    describe '#add_new_pizza' do
      it 'adds a new pizza to the menu' do
        new_pizza_prices = { regular: 200, medium: 300, large: 400 }
        service.add_new_pizza(:vegetarian, :new_veggie_special, new_pizza_prices)

        menu = service.menu.base_prices[:vegetarian]
        expect(menu[:new_veggie_special]).to eq(new_pizza_prices)
      end
    end

    describe '#add_new_topping' do
      it 'adds a new topping to the menu' do
        service.add_new_topping(:veg, :broccoli, 20)
        topping_prices = service.menu.topping_prices[:veg]
        expect(topping_prices[:broccoli]).to eq(20)
      end
    end

    describe '#add_new_side' do
      it 'adds a new side to the menu' do
        service.add_new_side(:garlic_bread, 60)
        side_prices = service.menu.side_prices
        expect(side_prices[:garlic_bread]).to eq(60)
      end
    end

    describe '#change_price' do
      it 'changes the price of an existing pizza' do
        new_price = { regular: 160, medium: 240, large: 320 }
        service.change_price(:pizza, :deluxe_veggie, new_price)
        expect(service.menu.base_prices[:vegetarian][:deluxe_veggie]).to eq(new_price)
      end

      it 'changes the price of an existing topping' do
        new_price = 50
        service.change_price(:topping, :capsicum, new_price)
        expect(service.menu.topping_prices[:veg][:capsicum]).to eq(new_price)
      end

      it 'changes the price of an existing side' do
        new_price = 65
        service.change_price(:side, :cold_drink, new_price)
        expect(service.menu.side_prices[:cold_drink]).to eq(new_price)
      end
    end
  end
end
