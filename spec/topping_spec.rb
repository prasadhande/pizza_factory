# spec/topping_spec.rb
require 'rspec'
require_relative '../lib/topping'

RSpec.describe Topping do
  let(:topping) { Topping.new("Mushrooms", 25, true) }
  let(:non_veg_topping) { Topping.new("Pepperoni", 30, false) }

  describe "#initialize" do
    it "correctly initializes a topping" do
      expect(topping.name).to eq("Mushrooms")
      expect(topping.price).to eq(25)
      expect(topping.vegetarian).to be true
    end

    it "raises an error if price is negative" do
      expect { Topping.new("Invalid", -10, true) }.to raise_error(ArgumentError, "Price cannot be negative")
    end
  end

  describe "#vegetarian" do
    it "returns true for a vegetarian topping" do
      expect(topping.vegetarian).to be true
    end

    it "returns false for a non-vegetarian topping" do
      expect(non_veg_topping.vegetarian).to be false
    end
  end
end