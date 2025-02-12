# Represents a Crust with its name.
class Crust
  attr_reader :name

  # Initializes a Crust object.
  # @param name [String] The name of the crust.
  def initialize(name)
    if name.empty?
      raise ArgumentError, "Crust name cannot be empty"  # Correct way to raise the error
    end
    @name = name
  end
end