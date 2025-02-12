require 'rspec'
require_relative '../lib/order'
require_relative '../lib/order_item'
require_relative '../lib/pizza'
require_relative '../lib/crust'
require_relative '../lib/topping'
require_relative '../lib/side_item'
require_relative '../lib/side'
require_relative '../lib/order_rule'

RSpec.describe Order do
  let(:order) { Order.new }
  let(:pizza) { Pizza.new("Test Pizza", { "Regular" => 100, "Medium" => 150, "Large" => 200 }, true) }
  let(:crust) { Crust.new("Thin Crust") }
  let(:topping1) { Topping.new("Mushrooms", 25, true) }
  let(:topping2) { Topping.new("Olives", 20, true) }
  let(:side) { Side.new("Coke", 50) }
  let(:non_veg_pizza) { Pizza.new("Non-Veg Pizza", { "Regular" => 120, "Medium" => 180, "Large" => 240 }, false) }
  let(:non_veg_topping) { Topping.new("Pepperoni", 30, false) }

  describe "#add_item" do
    it "adds an order item to the order" do
      order_item = OrderItem.new(pizza, "Medium", crust, [topping1, topping2])
      order.add_item(order_item)
      expect(order.order_items).to include(order_item)
    end

    it "raises error if order_item is not OrderItem object" do
        expect { order.add_item("not an order item") }.to raise_error(TypeError)
    end
  end

  describe "#add_side_item" do
    it "adds a side item to the order" do
      side_item = SideItem.new(side, 2)
      order.add_side_item(side_item)
      expect(order.side_items).to include(side_item)
    end

    it "raises error if side_item is not SideItem object" do
        expect { order.add_side_item("not a side item") }.to raise_error(TypeError)
    end
  end

  describe "#total_price" do
    it "calculates the correct total price" do
      order_item1 = OrderItem.new(pizza, "Medium", crust, [topping1, topping2]) # Has toppings, vegetarian
      order_item2 = OrderItem.new(non_veg_pizza, "Regular", crust) # No toppings, NON-VEGETARIAN! 
      side_item = SideItem.new(side, 2)
      order.add_item(order_item1)
      order.add_item(order_item2)
      order.add_side_item(side_item)
      expect(order.total_price).to eq(415) 
    end

    it "calculates the correct total price with no items" do
      expect(order.total_price).to eq(0)
    end

    it "does not raise an error for empty order" do
      expect { order.total_price }.not_to raise_error
    end
  end

  describe "#validate" do
    it "does not raise an error for a valid order" do
      order_item = OrderItem.new(pizza, "Medium", crust, [topping1, topping2])
      order.add_item(order_item)
      expect { order.validate }.not_to raise_error
    end

    it "raises an error for vegetarian pizza with non-veg topping" do
      order_item = OrderItem.new(pizza, "Medium", crust, [non_veg_topping])
      order.add_item(order_item)
      expect { order.validate }.to raise_error("Vegetarian pizza cannot have non-vegetarian toppings")
    end

    it "raises an error for non-veg pizza with paneer topping" do
      order_item = OrderItem.new(non_veg_pizza, "Medium", crust, [Topping.new("Paneer", 35, true)])
      order.add_item(order_item)
      expect { order.validate }.to raise_error("Non-vegetarian pizza cannot have paneer topping")
    end

    it "raises an error for non-veg pizza with multiple non-veg toppings" do
        order_item = OrderItem.new(non_veg_pizza, "Medium", crust, [non_veg_topping, Topping.new("Bacon", 40, false)])
        order.add_item(order_item)
        expect { order.validate }.to raise_error("Only one non-veg topping allowed per non-veg pizza")
    end

    it "does not raise an error for non-veg pizza with one non-veg topping" do
        order_item = OrderItem.new(non_veg_pizza, "Medium", crust, [non_veg_topping])
        order.add_item(order_item)
        expect { order.validate }.not_to raise_error
    end
  end
end