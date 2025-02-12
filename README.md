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
    rspec spec/topping_spec.rb
    rspec spec/crust_spec.rb
    rspec spec/side_spec.rb
    rspec spec/order_item_spec.rb
    rspec spec/side_item_spec.rb
    rspec spec/order_spec.rb
    rspec spec/pizza_factory_spec.rb
    rspec spec/order_rule_spec.rb
    ```

    This is useful for focusing on specific parts of the system during development.


### Example Usage 

```ruby
factory = PizzaFactory.new

# Add pizzas to the menu
factory.add_pizza(Pizza.new("Margherita", { "Regular" => 100, "Medium" => 150, "Large" => 200 }, true))
# ... add more pizzas

# Add toppings
factory.add_topping(Topping.new("Mushrooms", 20, true))
# ... add more toppings

# Add crusts
factory.add_crust(Crust.new("Thin Crust"))
# ... add more crusts

# Add sides
factory.add_side(Side.new("Coke", 50))
# ... add more sides

# Create an order
items = [
  { pizza: "Margherita", size: "Medium", crust: "Thin Crust", toppings: ["Mushrooms"] }
]

side_items = [{side: "Coke", quantity: 2}]

order = factory.create_order(items, side_items)

# Get the total price
puts order.total_price # Output the total price

# Handle potential errors (e.g., invalid input, business rule violations)
begin
  order = factory.create_order(items, side_items)
rescue RuntimeError => e
  puts "Error: #{e.message}"
end
