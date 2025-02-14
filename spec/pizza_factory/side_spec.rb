# spec/pizza_factory/side_spec.rb

require 'rspec'
require_relative '../../lib/pizza_factory/side'

module PizzaFactory
  RSpec.describe Side do
    let(:side) { Side.new(:cold_drink) }

    describe '#initialize' do
      it 'creates a side with the specified name' do
        expect(side.name).to eq(:cold_drink)
      end
    end
  end
end
