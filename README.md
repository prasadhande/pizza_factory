# Pizza Factory

This project implements a Pizza Factory system, allowing users to place orders for pizzas, sides, and customize their pizzas with various toppings and crusts. The system includes features for menu management, inventory tracking, and business rule enforcement.

## Features

*   **Menu Management:**  Add, view, and manage pizzas, toppings, crusts, and sides.  Each pizza has a name, price by size (Regular, Medium, Large), and a vegetarian flag. Toppings also have names, prices, and vegetarian flags. Crusts are identified by name, and sides by name and price.
*   **Inventory Tracking:**  Track the available quantity of each topping.  Orders cannot be placed if there is insufficient inventory.
*   **Order Creation:** Create pizza orders with specified sizes, crusts, and toppings.  Orders can also include sides.  The system handles the "Large pizza two free toppings" rule automatically.
*   **Business Rule Enforcement:** The system enforces the following business rules:
    *   Vegetarian pizzas cannot have non-vegetarian toppings.
    *   Non-vegetarian pizzas cannot have paneer topping.
    *   Non-vegetarian pizzas can have at most one non-vegetarian topping.
    *   Large pizzas get two free toppings (if more than two are selected, only the first two are applied).
*   **Order Validation:**  Orders are validated against the defined business rules before they are finalized.  Invalid orders will raise exceptions.
*   **Testability:** The project includes comprehensive RSpec tests for all classes and business rules, ensuring the system functions as expected.

## Getting Started

### Prerequisites

*   Ruby (version 3.1.2 or higher)
*   Bundler (recommended)

### Installation

1.  Clone the repository:

    ```bash
    git clone [https://github.com/prasadhande/pizza_factory.git](https://www.google.com/search?q=https://github.com/YOUR_USERNAME/pizza_factory.git)  # Replace with your repo URL
    ```

2.  Navigate to the project directory:

    ```bash
    cd pizza_factory
    ```

3.  Install dependencies (using Bundler):

    ```bash
    bundle install
    ```

## Usage

### Running the Tests

1.  Ensure you are in the project's root directory.
2.  Run the tests using RSpec:

    ```bash
    rspec
    ```

    Or, if using Bundler:

    ```bash
    bundle exec rspec
    ```

3. You can also run individual spec files. For example, to run the `pizza_spec.rb` file:

    ```bash
    rspec spec/pizza_spec.rb
    ```

    Similarly, you can run other individual spec files like:

    ```bash
    rspec spec/pizza_factory/service_spec.rb
    rspec spec/pizza_factory/pizza_spec.rb
    rspec spec/pizza_factory/topping_spec.rb
    rspec spec/pizza_factory/side_spec.rb

    ```

    This is useful for focusing on specific parts of the system during development.


### Example Usage 

```ruby
require_relative 'lib/pizza_factory'

### Initialize the service
service = PizzaFactory::Service.new


# Restock inventory with necessary ingredients
service.restock_inventory(:deluxe_veggie, 10)
service.restock_inventory(:new_hand_tossed, 10)
service.restock_inventory(:capsicum, 10)
service.restock_inventory(:mushroom, 10)
service.restock_inventory(:extra_cheese, 10)
service.restock_inventory(:cold_drink, 10)


# Create a new order
order = PizzaFactory::Order.new

# Create a pizza
pizza = PizzaFactory::Pizza.new(:vegetarian, :deluxe_veggie, :regular, :new_hand_tossed)
pizza.add_topping(PizzaFactory::Topping.new(:veg, :capsicum))
pizza.add_topping(PizzaFactory::Topping.new(:veg, :mushroom))
pizza.extra_cheese = true

# Add pizza to order
order.add_pizza(pizza)

# Add side to order
order.add_side(PizzaFactory::Side.new(:cold_drink))

# Verify and place the order
puts service.place_order(order) # Output: "Order placed successfully! Your total is Rs. 295."


# Add new pizza to the menu
service.add_new_pizza(:vegetarian, :new_veggie_special, { regular: 200, medium: 300, large: 400 })

# Add new topping to the menu
service.add_new_topping(:veg, :broccoli, 20)

# Add new side to the menu
service.add_new_side(:garlic_bread, 60)


# Change the price of an existing pizza
service.change_price(:pizza, :deluxe_veggie, { regular: 160, medium: 240, large: 320 })

# Change the price of an existing topping
service.change_price(:topping, :capsicum, 30)

# Change the price of an existing side
service.change_price(:side, :cold_drink, 70)




## Full Script Example

require_relative 'lib/pizza_factory'

# Initialize the service
service = PizzaFactory::Service.new

# Restock inventory with necessary ingredients
service.restock_inventory(:deluxe_veggie, 10)
service.restock_inventory(:new_hand_tossed, 10)
service.restock_inventory(:capsicum, 10)
service.restock_inventory(:mushroom, 10)
service.restock_inventory(:extra_cheese, 10)
service.restock_inventory(:cold_drink, 10)

# Create a new order
order = PizzaFactory::Order.new

# Create a pizza
pizza = PizzaFactory::Pizza.new(:vegetarian, :deluxe_veggie, :regular, :new_hand_tossed)
pizza.add_topping(PizzaFactory::Topping.new(:veg, :capsicum))
pizza.add_topping(PizzaFactory::Topping.new(:veg, :mushroom))
pizza.extra_cheese = true

# Add pizza to order
order.add_pizza(pizza)

# Add side to order
order.add_side(PizzaFactory::Side.new(:cold_drink))

# Verify and place the order
puts service.place_order(order) # Output: "Order placed successfully! Your total is Rs. 295."

# Add new pizza to the menu
service.add_new_pizza(:vegetarian, :new_veggie_special, { regular: 200, medium: 300, large: 400 })

# Add new topping to the menu
service.add_new_topping(:veg, :broccoli, 20)

# Add new side to the menu
service.add_new_side(:garlic_bread, 60)

# Change the price of an existing pizza
service.change_price(:pizza, :deluxe_veggie, { regular: 160, medium: 240, large: 320 })

# Change the price of an existing topping
service.change_price(:topping, :capsicum, 30)

# Change the price of an existing side
service.change_price(:side, :cold_drink, 70)
