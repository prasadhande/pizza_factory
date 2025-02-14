# spec/pizza_factory/topping_spec.rb

require 'rspec'
require_relative '../../lib/pizza_factory/topping'

module PizzaFactory
  RSpec.describe Topping do
    let(:topping) { Topping.new(:veg, :capsicum) }

    describe '#initialize' do
      it 'creates a topping with specified attributes' do
        expect(topping.category).to eq(:veg)
        expect(topping.name).to eq(:capsicum)
      end
    end
  end
end
