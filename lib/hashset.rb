# frozen_string_literal: true

require_relative './setnode'

# A class for a set
class HashSet
  LOAD_FACTOR = 0.75

  def initialize
    @buckets = Array.new(16)
  end

  def hash(key)
    hash_code = 0
    prime_number = 31

    key.each_char { |char| hash_code = prime_number * hash_code + char.ord }

    hash_code
  end

  def set(key)
    hash_code = hash(key) % @buckets.length

    @buckets.concat(Array.new(16)) if (@buckets.length - @buckets.count(&:nil?)) / @buckets.length >= LOAD_FACTOR

    if @buckets[hash_code].nil?
      @buckets[hash_code] = SetNode.new(key)
    else
      handle_non_empty_bucket(@buckets[hash_code], key)
    end
  end

  def handle_non_empty_bucket(node, key)
    loop do
      break if node.key == key

      if node.next_node.nil?
        node.next_node = SetNode.new(key)

        break
      end

      node = node.next_node
    end
  end

  def has?(key)
    hash_code = hash(key) % @buckets.length
    node = @buckets[hash_code]

    until node.nil?
      return true if node.key == key

      node = node.next_node
    end

    false
  end

  def remove(key)
    hash_code = hash(key) % @buckets.length

    return if @buckets[hash_code].nil?

    if @buckets[hash_code].key == key
      @buckets[hash_code] = @buckets[hash_code].next_node
    else
      handle_list_deletion(@buckets[hash_code], key)
    end
  end

  def handle_list_deletion(node, key)
    until node.nil?
      if node.next_node.key == key
        node.next_node = node.next_node.next_node

        break
      end

      node = node.next_node
    end
  end

  def length
    counter = 0

    @buckets.each do |node|
      until node.nil?
        counter += 1

        node = node.next_node
      end
    end

    counter
  end

  def clear
    @buckets = Array.new(16)
  end

  def keys
    keys = []

    @buckets.each do |node|
      until node.nil?
        keys.push(node.key)

        node = node.next_node
      end
    end

    keys
  end
end
