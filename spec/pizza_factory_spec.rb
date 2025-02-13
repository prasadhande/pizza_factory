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

  describe "#create_order" do
    it "creates a valid order" do
      items = [{ pizza: "Deluxe Veggie", size: "Medium", crust: "New hand tossed", toppings: ["Black olive", "Capsicum"] }]
      order = factory.create_order(items)
      expect(order.total_price).to eq(245) # 200 + 20 + 25
    end

    it "creates a valid order with sides" do
      items = [{ pizza: "Deluxe Veggie", size: "Medium", crust: "New hand tossed" }]
      side_items = [{ side: "Cold drink", quantity: 2 }]
      order = factory.create_order(items, side_items)
      expect(order.total_price).to eq(310) # 200 + (55 * 2)
    end

    it "raises an error for invalid pizza" do
      expect { factory.create_order([{ pizza: "Invalid Pizza", size: "Medium", crust: "New hand tossed" }]) }.to raise_error("Invalid pizza name: Invalid Pizza")
    end

    it "raises an error if items is not an array" do
      expect { factory.create_order("not an array") }.to raise_error(TypeError, "items must be an array")
    end

    it "raises an error if side_items is not an array" do
      expect { factory.create_order([], "not an array") }.to raise_error(TypeError, "side_items must be an array")
    end

    it "raises error if size is nil" do
      items = [{ pizza: "Deluxe Veggie", size: nil, crust: "New hand tossed", toppings: ["Black olive", "Capsicum"] }]
      expect { factory.create_order(items) }.to raise_error("Size is required")
    end

    describe "Business Rule Validation" do
      it "raises an error for vegetarian pizza with non-veg topping" do
        items = [{ pizza: "Deluxe Veggie", size: "Medium", crust: "New hand tossed", toppings: ["Chicken tikka"] }]
        expect { factory.create_order(items) }.to raise_error("Vegetarian pizza cannot have non-vegetarian toppings")
      end

      it "raises an error for non-veg pizza with paneer topping" do
        items = [{ pizza: "Non-Veg Supreme", size: "Medium", crust: "New hand tossed", toppings: ["Paneer"] }]
        expect { factory.create_order(items) }.to raise_error("Non-vegetarian pizza cannot have paneer topping")
      end

      it "raises an error for non-veg pizza with multiple non-veg toppings" do
        items = [{ pizza: "Non-Veg Supreme", size: "Medium", crust: "New hand tossed", toppings: ["Chicken tikka", "Barbeque chicken"] }]
        expect { factory.create_order(items) }.to raise_error("Only one non-veg topping allowed per non-veg pizza")
      end

      it "handles large pizza with two free toppings" do
        items = [{ pizza: "Deluxe Veggie", size: "Large", crust: "New hand tossed", toppings: ["Black olive", "Capsicum", "Paneer"] }]
        order = factory.create_order(items)
        expect(order.total_price).to eq(350) # Corrected price: 325 + 25 (Paneer)
      end

      it "handles large pizza with only two toppings (both free)" do
        items = [{ pizza: "Deluxe Veggie", size: "Large", crust: "New hand tossed", toppings: ["Black olive", "Capsicum"] }]
        order = factory.create_order(items)
        expect(order.total_price).to eq(370) # Corrected price: 325 + 20 + 25
      end

      it "does not raise an error for a valid non-veg pizza with one non-veg topping" do
        items = [{ pizza: "Non-Veg Supreme", size: "Medium", crust: "New hand tossed", toppings: ["Chicken tikka"] }]
        expect { factory.create_order(items) }.not_to raise_error
      end

      it "does not raise an error for a valid vegetarian pizza with vegetarian toppings" do
        items = [{ pizza: "Deluxe Veggie", size: "Medium", crust: "New hand tossed", toppings: ["Black olive", "Capsicum"] }]
        expect { factory.create_order(items) }.not_to raise_error
      end
    end # End of "Business Rule Validation" describe block

    it "raises an error for insufficient inventory" do
      items = [{ pizza: "Deluxe Veggie", size: "Medium", crust: "New hand tossed", toppings: ["Black olive", "Capsicum", "Paneer"] }]
      factory.restock_inventory("Paneer", 0) # Exhaust Paneer inventory
      expect { factory.create_order(items) }.to raise_error("Insufficient inventory for Paneer")
    end

    it "creates an order with multiple pizzas" do
      items = [
        { pizza: "Deluxe Veggie", size: "Medium", crust: "New hand tossed", toppings: ["Black olive", "Capsicum"] },
        { pizza: "Non-Veg Supreme", size: "Regular", crust: "New hand tossed", toppings: ["Chicken tikka"] }
      ]
      order = factory.create_order(items)
      expect(order.total_price).to eq(470) # 200 + 20 + 25 + 190 + 35
    end

    it "raises error if topping name is invalid" do
      items = [{ pizza: "Deluxe Veggie", size: "Medium", crust: "New hand tossed", toppings: ["Invalid Topping"] }]
      expect { factory.create_order(items) }.to raise_error("Invalid topping name: Invalid Topping")
    end

    it "raises error if pizza name is invalid" do
      items = [{ pizza: "Invalid Pizza", size: "Medium", crust: "New hand tossed", toppings: ["Black olive"] }]
      expect { factory.create_order(items) }.to raise_error("Invalid pizza name: Invalid Pizza")
    end

    it "raises error if crust name is invalid" do
      items = [{ pizza: "Deluxe Veggie", size: "Medium", crust: "Invalid Crust", toppings: ["Black olive"] }]
      expect { factory.create_order(items) }.to raise_error("Invalid crust name: Invalid Crust")
    end

    it "creates order with no toppings" do
      items = [{ pizza: "Deluxe Veggie", size: "Medium", crust: "New hand tossed" }]
      order = factory.create_order(items)
      expect(order.total_price).to eq(200) # 200
    end

    it "creates order with no sides" do
      items = [{ pizza: "Deluxe Veggie", size: "Medium", crust: "New hand tossed", toppings: ["Black olive", "Capsicum"] }]
      order = factory.create_order(items)
      expect(order.total_price).to eq(245) # 200 + 20 + 25
    end

    it "creates order with quantity 1 if no quantity provided for sides" do
      items = [{ pizza: "Deluxe Veggie", size: "Medium", crust: "New hand tossed" }]
      side_items = [{ side: "Cold drink" }]
      order = factory.create_order(items, side_items)
      expect(order.total_price).to eq(255) # 200 + 55
    end

    it "correctly calculates price for large pizza with free toppings" do
      items = [{ pizza: "Deluxe Veggie", size: "Large", crust: "New hand tossed", toppings: ["Black olive", "Capsicum", "Paneer"] }]
      order = factory.create_order(items)
      expect(order.total_price).to eq(360) # 325 + 35 (Paneer, two free toppings)
    end

    it "correctly calculates price for large pizza with only free toppings" do
      items = [{ pizza: "Deluxe Veggie", size: "Large", crust: "New hand tossed", toppings: ["Black olive", "Capsicum"] }]
      order = factory.create_order(items)
      expect(order.total_price).to eq(370) # 325 + 20 + 25
    end

        it "handles multiple sides with varying quantities" do
      items = [{ pizza: "Deluxe Veggie", size: "Medium", crust: "New hand tossed" }]
      side_items = [{ side: "Cold drink", quantity: 2 }, {side: "Cold drink", quantity: 3}]
      order = factory.create_order(items, side_items)
      expect(order.total_price).to eq(475) # 200 + (55 * 2) + (55 * 3)
    end

        it "handles multiple sides with no quantity specified" do
      items = [{ pizza: "Deluxe Veggie", size: "Medium", crust: "New hand tossed" }]
      side_items = [{ side: "Cold drink"}, {side: "Cold drink"}]
      order = factory.create_order(items, side_items)
      expect(order.total_price).to eq(310) # 200 + (55 * 2)
    end


  end
end