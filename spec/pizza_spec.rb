# spec/pizza_spec.rb
require 'rspec'
require_relative '../lib/pizza'

RSpec.describe Pizza do
  let(:pizza) { Pizza.new("Test Pizza", { "Regular" => 100, "Medium" => 150, "Large" => 200 }, true) }
  let(:non_veg_pizza) { Pizza.new("Non-Veg Pizza", { "Regular" => 120, "Medium" => 180, "Large" => 240 }, false) }

  describe "#initialize" do
    it "correctly initializes a pizza" do
      expect(pizza.name).to eq("Test Pizza")
      expect(pizza.price_by_size).to eq({ "Regular" => 100, "Medium" => 150, "Large" => 200 })
      expect(pizza.vegetarian).to be true
    end
  end

  describe "#price" do
    it "returns the correct price for a given size" do
      expect(pizza.price("Regular")).to eq(100)
      expect(pizza.price("Medium")).to eq(150)
      expect(pizza.price("Large")).to eq(200)
    end

    it "raises an error for an empty size string" do  # Example failing test
      expect { pizza.price("") }.to raise_error("Invalid pizza size")
    end

    it "raises an error for a size with spaces" do # Example failing test
        expect { pizza.price(" Large ") }.to raise_error("Invalid pizza size")
    end


    it "raises an error for an invalid size" do
      expect { pizza.price("Extra Large") }.to raise_error("Invalid pizza size")
    end
  end

  describe "#vegetarian" do
    it "returns true for a vegetarian pizza" do
      expect(pizza.vegetarian).to be true
    end

    it "returns false for a non-vegetarian pizza" do
      expect(non_veg_pizza.vegetarian).to be false
    end
  end

  describe "#price_by_size" do
    it "returns the correct price hash" do
      expect(pizza.price_by_size).to eq({ "Regular" => 100, "Medium" => 150, "Large" => 200 })
    end
  end
end