# spec/side_spec.rb
require 'rspec'
require_relative '../lib/side'

RSpec.describe Side do
  let(:side) { Side.new("Coke", 50) }

  describe "#initialize" do
    it "correctly initializes a side" do
      expect(side.name).to eq("Coke")
      expect(side.price).to eq(50)
    end

    it "raises an error if price is zero" do
      expect { Side.new("Invalid", 0) }.to raise_error(ArgumentError) # Or a custom error
    end

    it "raises an error if price is negative" do
        expect { Side.new("Invalid", -10) }.to raise_error(ArgumentError)
    end
  end
end