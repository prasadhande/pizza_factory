# spec/crust_spec.rb
require 'rspec'
require_relative '../lib/crust'

RSpec.describe Crust do
  let(:crust) { Crust.new("Thin Crust") }

  describe "#initialize" do
    it "correctly initializes a crust" do
      expect(crust.name).to eq("Thin Crust")
    end

    it "raises error if name is empty" do
        expect { Crust.new("") }.to raise_error(ArgumentError)
      end
  end
end