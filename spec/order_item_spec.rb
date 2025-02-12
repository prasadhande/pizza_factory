require 'rspec'
require_relative '../lib/order_item'
require_relative '../lib/pizza'
require_relative '../lib/crust'
require_relative '../lib/topping'

RSpec.describe OrderItem do
  let(:pizza) { Pizza.new("Test Pizza", { "Regular" => 100, "Medium" => 150, "Large" => 200 }, true) }
  let(:crust) { Crust.new("Thin Crust") }
  let(:topping1) { Topping.new("Mushrooms", 25, true) }
  let(:topping2) { Topping.new("Olives", 20, true) }

  describe "#initialize" do
    it "correctly initializes an order item" do
      order_item = OrderItem.new(pizza, "Medium", crust, [topping1, topping2])
      expect(order_item.pizza).to eq(pizza)
      expect(order_item.size).to eq("Medium")
      expect(order_item.crust).to eq(crust)
      expect(order_item.toppings).to eq([topping1, topping2])
    end
  end

  describe "#price" do
    it "calculates the correct price" do
      order_item = OrderItem.new(pizza, "Medium", crust, [topping1, topping2])
      expect(order_item.price).to eq(195) # 150 + 25 + 20
    end

    it "calculates the correct price with no toppings" do
      order_item = OrderItem.new(pizza, "Medium", crust)
      expect(order_item.price).to eq(150)
    end

    it "returns 0 if pizza and size are nil and there are no toppings" do
      order_item = OrderItem.new(nil, nil, crust, []) # Empty toppings array
      expect(order_item.price).to eq(0)
    end

    it "returns 0 if pizza and size are nil and toppings are nil" do
      order_item = OrderItem.new(nil, nil, crust, nil) # No toppings!
      expect(order_item.price).to eq(0)
    end

    it "returns 0 if pizza is nil and there are toppings" do # Corrected logic
      order_item = OrderItem.new(nil, "Medium", crust, [topping1, topping2])
      expect(order_item.price).to eq(0) # Price should be 0 if pizza is nil
    end
  end
end