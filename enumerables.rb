# rubocop:disable Metrics/ModuleLength
# rubocop:disable Metrics/PerceivedComplexity,Metrics/CyclomaticComplexity
module Enumerable
  def my_each
    return to_enum(:my_each) unless block_given?

    each do |num|
      yield(num)
    end
  end

  def my_each_with_index
    return to_enum(:my_each_with_index) unless block_given?

    i = 0
    my_each do |num|
      yield(num, i)
      i += 1
    end
  end

  def my_select
    result = []
    return to_enum unless block_given?

    my_each do |x|
      result << x if yield(x)
    end
    result
  end

  def my_all?(pattern = nil)
    if pattern.nil?
      if block_given?
        my_each { |value| return false unless yield(value) }
      else my_each { |value| return false unless value }
      end
    elsif pattern.is_a?(Regexp)
      my_each { |value| return false unless value.match(pattern) }
    elsif pattern.is_a?(Module)
      my_each { |value| return false unless value.is_a?(pattern) }
    else
      my_each { |value| return false unless value == pattern }
    end
    true
  end

  def my_any?(var = nil)
    unless var.nil?
      if var.is_a?(Regexp)
        my_each { |val| return true if val.match(var) }
      elsif var.is_a?(Module)
        my_each { |val| return true if val.is_a?(var) }
      else
        my_each { |val| return true if val == var }
      end
      return false
    end
    return true unless block_given?

    my_each do |num|
      return true if yield(num)
    end
    false
  end

  def my_none?(var = nil)
    unless var.nil?
      if var.is_a?(Regexp)
        my_each { |val| return false if val.match(var) }
      elsif var.is_a?(Module)
        my_each { |val| return false if val.is_a?(var) }
      else
        my_each { |val| return false if val == var }
      end
      return true
    end
    return false unless block_given?

    my_each do |num|
      return false if yield(num)
    end
    true
  end

  def my_count(argument = nil)
    if block_given?
      counter = 0
      my_each do |i|
        counter += 1 if yield(i)
      end
      counter
    elsif !argument.nil?
      output = my_select { |i| i == argument }
      output.size
    else
      size
    end
  end

  def my_map(my_proc = nil)
    array = []
    my_each { |x| array << my_proc.call(x) } if my_proc
    my_each { |x| array << yield(x) } if block_given?

    array
  end

  def my_inject(accumulator = nil, operation = nil, &block)
    block = case operation
            when Symbol
              ->(acc, value) { acc.send(operation, value) }
            when nil
              block
            else
              raise ArgumentError, 'the operation provided must be a symbol'
            end
    if accumulator.nil?
      ignore_first = true
      accumulator = first
    end
    index = 0
    each do |element|
      accumulator = block.call(accumulator, element) unless ignore_first && index.zero?
      index += 1
    end
    accumulator
  end

  def multiply_els(array)
    array.my_inject { |result, x| result * x }
  end
end
# rubocop:enable Metrics/ModuleLength
# rubocop:enable Metrics/PerceivedComplexity,Metrics/CyclomaticComplexity
