# Abstract class for order rules.
class OrderRule
  # Checks if the rule applies to the given order item.
  # @param order_item [OrderItem] The order item to check.
  # @return [Boolean] True if the rule applies, false otherwise.
  def applies?(order_item)
    raise NotImplementedError
  end

  # Validates the order item against the rule.
  # @param order_item [OrderItem] The order item to validate.
  # @raise [RuntimeError] If the rule is violated.
  def validate(order_item)
    raise NotImplementedError
  end
end

# Rule: Vegetarian pizza cannot have non-vegetarian toppings.
class VegetarianPizzaNonVegToppingRule < OrderRule
  def applies?(order_item)
    order_item.pizza.vegetarian
  end

  def validate(order_item)
    order_item.toppings.each do |topping|
      raise "Vegetarian pizza cannot have non-vegetarian toppings" unless topping.vegetarian
    end
  end
end

# Rule: Non-vegetarian pizza cannot have paneer topping.
class NonVegPizzaNoPaneerRule < OrderRule
  def applies?(order_item)
    !order_item.pizza.vegetarian
  end

  def validate(order_item)
    order_item.toppings.each do |topping|
      raise "Non-vegetarian pizza cannot have paneer topping" if topping.name == "Paneer"
    end
  end
end

# Rule: Non-vegetarian pizza can have at most one non-vegetarian topping.
class OnlyOneNonVegToppingRule < OrderRule
  def applies?(order_item)
    !order_item.pizza.vegetarian
  end

  def validate(order_item)
    if order_item.toppings.select { |t| !t.vegetarian }.length > 1
      raise "Only one non-veg topping allowed per non-veg pizza"
    end
  end
end

# Rule: Large pizzas get two free toppings.
class LargePizzaTwoFreeToppingsRule < OrderRule
  def applies?(order_item)
    order_item.size == "Large"
  end

  def validate(order_item)
    # Handled in PizzaFactory during order creation.
  end
end