# frozen_string_literal: true

# Node class for hashmap
class Node
  attr_accessor :key, :value, :next_node

  def initialize(key, value)
    @key = key
    @value = value
    @next_node = nil
  end
end
