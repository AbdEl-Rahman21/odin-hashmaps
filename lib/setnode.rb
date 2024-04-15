# frozen_string_literal: true

# Node class for hashset
class SetNode
  attr_accessor :key, :next_node

  def initialize(key)
    @key = key
    @next_node = nil
  end
end
