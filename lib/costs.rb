# frozen_string_literal: true

# Cost definitions for pizzas, crusts, toppings, and sides
module Costs
  # Hash containing pizza prices by name and size
  PIZZA_COSTS = {
    'Deluxe Veggie' => { 'Regular' => 150, 'Medium' => 200, 'Large' => 325 },
    'Cheese and Corn' => { 'Regular' => 175, 'Medium' => 375, 'Large' => 475 },
    'Paneer Tikka' => { 'Regular' => 160, 'Medium' => 290, 'Large' => 340 },
    'Non-Veg Supreme' => { 'Regular' => 190, 'Medium' => 325, 'Large' => 425 },
    'Chicken Tikka' => { 'Regular' => 210, 'Medium' => 370, 'Large' => 500 },
    'Pepper Barbecue Chicken' => { 'Regular' => 220, 'Medium' => 380, 'Large' => 525 }
  }.freeze

  # Hash containing crust prices by crust name
  CRUST_COSTS = {
    'New hand tossed' => 0,
    'Wheat thin crust' => 20,
    'Cheese Burst' => 75,
    'Fresh pan pizza' => 50
  }.freeze

  # Hash containing topping prices by topping name
  TOPPING_COSTS = {
    'Black olive' => 20,
    'Capsicum' => 25,
    'Paneer' => 35,
    'Mushroom' => 30,
    'Fresh tomato' => 10,
    'Chicken tikka' => 35,
    'Barbeque chicken' => 45,
    'Grilled chicken' => 40,
    'Extra cheese' => 35
  }.freeze

  # Hash containing side prices by side name
  SIDE_COSTS = {
    'Cold drink' => 55,
    'Mousse cake' => 90
  }.freeze
end
