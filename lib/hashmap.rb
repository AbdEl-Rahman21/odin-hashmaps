# frozen_string_literal: true

require_relative './node'

# A class for a hash table
class HashMap
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

  def set(key, value)
    hash_code = hash(key) % @buckets.length

    @buckets.concat(Array.new(16)) if (@buckets.length - @buckets.count(&:nil?)) / @buckets.length >= LOAD_FACTOR

    if @buckets[hash_code].nil?
      @buckets[hash_code] = Node.new(key, value)
    else
      handle_non_empty_bucket(@buckets[hash_code], key, value)
    end
  end

  def handle_non_empty_bucket(node, key, value)
    loop do
      if node.key == key
        node.value = value

        break
      elsif node.next_node.nil?
        node.next_node = Node.new(key, value)

        break
      end

      node = node.next_node
    end
  end

  def get(key)
    hash_code = hash(key) % @buckets.length
    node = @buckets[hash_code]

    until node.nil?
      return node.value if node.key == key

      node = node.next_node
    end

    node
  end

  def has?(key)
    return true unless get(key).nil?

    false
  end

  def remove(key)
    hash_code = hash(key) % @buckets.length
    value = nil

    return value if @buckets[hash_code].nil?

    if @buckets[hash_code].key == key
      value = @buckets[hash_code].value

      @buckets[hash_code] = @buckets[hash_code].next_node
    else
      value = handle_list_deletion(@buckets[hash_code], key)
    end

    value
  end

  def handle_list_deletion(node, key)
    value = nil

    until node.nil?
      if node.next_node.key == key
        value = node.next_node.value

        node.next_node = node.next_node.next_node

        break
      end

      node = node.next_node
    end

    value
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

  def values
    values = []

    @buckets.each do |node|
      until node.nil?
        values.push(node.value)

        node = node.next_node
      end
    end

    values
  end

  def entries
    entries = []

    @buckets.each do |node|
      until node.nil?
        entries.push([node.key, node.value])

        node = node.next_node
      end
    end

    entries
  end
end
