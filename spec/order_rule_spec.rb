# spec/order_rule_spec.rb
require 'rspec'
require_relative '../lib/order_rule'
require_relative '../lib/pizza'
require_relative '../lib/topping'
require_relative '../lib/order_item' # Required for creating order items

RSpec.describe OrderRule do  # This is an abstract class, so we test the subclasses
  let(:pizza) { Pizza.new("Test Pizza", { "Regular" => 100 }, true) }
  let(:non_veg_pizza) { Pizza.new("Non-Veg Pizza", { "Regular" => 120 }, false) }
  let(:veg_topping) { Topping.new("Mushrooms", 25, true) }
  let(:non_veg_topping) { Topping.new("Pepperoni", 30, false) }
  let(:paneer_topping) { Topping.new("Paneer", 35, true) }

  describe VegetarianPizzaNonVegToppingRule do
    let(:rule) { VegetarianPizzaNonVegToppingRule.new }

    it "applies to vegetarian pizzas" do
      order_item = OrderItem.new(pizza, "Regular", nil)
      expect(rule.applies?(order_item)).to be true
    end

    it "does not apply to non-vegetarian pizzas" do
        order_item = OrderItem.new(non_veg_pizza, "Regular", nil)
        expect(rule.applies?(order_item)).to be false
    end

    it "raises an error for vegetarian pizza with non-veg topping" do
      order_item = OrderItem.new(pizza, "Regular", nil, [non_veg_topping])
      expect { rule.validate(order_item) }.to raise_error("Vegetarian pizza cannot have non-vegetarian toppings")
    end

    it "does not raise an error for vegetarian pizza with veg topping" do
        order_item = OrderItem.new(pizza, "Regular", nil, [veg_topping])
        expect { rule.validate(order_item) }.not_to raise_error
    end

    it "does not raise an error for empty toppings" do
        order_item = OrderItem.new(pizza, "Regular", nil, [])
        expect { rule.validate(order_item) }.not_to raise_error
    end
  end

  describe NonVegPizzaNoPaneerRule do
    let(:rule) { NonVegPizzaNoPaneerRule.new }

    it "applies to non-vegetarian pizzas" do
      order_item = OrderItem.new(non_veg_pizza, "Regular", nil)
      expect(rule.applies?(order_item)).to be true
    end

    it "does not apply to vegetarian pizzas" do
        order_item = OrderItem.new(pizza, "Regular", nil)
        expect(rule.applies?(order_item)).to be false
    end

    it "raises an error for non-veg pizza with paneer topping" do
        order_item = OrderItem.new(non_veg_pizza, "Regular", nil, [paneer_topping])
        expect { rule.validate(order_item) }.to raise_error("Non-vegetarian pizza cannot have paneer topping")
    end

      it "does not raise an error for non-veg pizza without paneer topping" do
        order_item = OrderItem.new(non_veg_pizza, "Regular", nil, [non_veg_topping])
        expect { rule.validate(order_item) }.not_to raise_error
    end

    it "does not raise an error for empty toppings" do
        order_item = OrderItem.new(non_veg_pizza, "Regular", nil, [])
        expect { rule.validate(order_item) }.not_to raise_error
    end
  end

  describe OnlyOneNonVegToppingRule do
    let(:rule) { OnlyOneNonVegToppingRule.new }

    it "applies to non-vegetarian pizzas" do
      order_item = OrderItem.new(non_veg_pizza, "Regular", nil)
      expect(rule.applies?(order_item)).to be true
    end

    it "does not apply to vegetarian pizzas" do
        order_item = OrderItem.new(pizza, "Regular", nil)
        expect(rule.applies?(order_item)).to be false
    end

    it "raises an error for non-veg pizza with multiple non-veg toppings" do
        order_item = OrderItem.new(non_veg_pizza, "Regular", nil, [non_veg_topping, Topping.new("Bacon", 40, false)])
        expect { rule.validate(order_item) }.to raise_error("Only one non-veg topping allowed per non-veg pizza")
    end

    it "does not raise an error for non-veg pizza with one non-veg topping" do
        order_item = OrderItem.new(non_veg_pizza, "Regular", nil, [non_veg_topping])
        expect { rule.validate(order_item) }.not_to raise_error
    end

    it "does not raise an error for empty toppings" do
        order_item = OrderItem.new(non_veg_pizza, "Regular", nil, [])
        expect { rule.validate(order_item) }.not_to raise_error
    end
  end

  describe LargePizzaTwoFreeToppingsRule do
    let(:rule) { LargePizzaTwoFreeToppingsRule.new }

    it "applies to large pizzas" do
        order_item = OrderItem.new(pizza, "Large", nil)
        expect(rule.applies?(order_item)).to be true
    end

    it "does not apply to other sizes" do
        order_item = OrderItem.new(pizza, "Medium", nil)
        expect(rule.applies?(order_item)).to be false
    end

    it "does not raise an error (handled in PizzaFactory)" do
        order_item = OrderItem.new(pizza, "Large", nil, [veg_topping, non_veg_topping, paneer_topping]) # More than 2 toppings
        expect { rule.validate(order_item) }.not_to raise_error
    end
  end
end