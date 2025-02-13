# lib/order_rules/no_order_cancellation_rule.rb
require_relative 'order_rule' # Inherit from OrderRule

class NoOrderCancellationRule < OrderRule
  def applies?(order) # Applies to the entire order
    true # This rule *always* applies
  end

  def validate(order)
    raise "Order cancellation is not allowed." if order.cancelled?
  end
end