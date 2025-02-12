# spec/side_item_spec.rb
require 'rspec'
require_relative '../lib/side_item'
require_relative '../lib/side'

RSpec.describe SideItem do
  let(:side) { Side.new("Coke", 50) }

  describe "#initialize" do
    it "correctly initializes a side item" do
      side_item = SideItem.new(side, 2)
      expect(side_item.side).to eq(side)
      expect(side_item.quantity).to eq(2)
    end
  end

  describe "#price" do
    it "calculates the correct price" do
      side_item = SideItem.new(side, 3)
      expect(side_item.price).to eq(150) # 50 * 3
    end

    it "returns 0 if quantity is zero" do
      side_item = SideItem.new(side, 0)
      expect(side_item.price).to eq(0)
    end

    it "raises error if quantity is negative" do
       side_item = SideItem.new(side, -1)
       expect { side_item.price }.to raise_error(ArgumentError)
    end
  end
end