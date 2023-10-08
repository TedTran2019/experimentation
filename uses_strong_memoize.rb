require_relative 'strong_memoize'
require 'byebug'

class Foo
  include StrongMemoize

  attr_accessor :toggle

  def initialize(toggle)
    @toggle = toggle
  end

  def a
    strong_memoize(:a) do
      puts 'MEMOIZED'
      100
    end
  end

  def b
    puts 'MEMOIZED'
    100
  end
  strong_memoize_attr :b

  def c
    return if toggle.zero?

    strong_memoize(:a) do
      puts 'MEMOIZED'
      100
    end
  end

  # Behavior for d isn't remotely correct as expected
  def d
    return if toggle.zero?

    puts 'MEMOIZED'
    100
  end
  strong_memoize_attr :d

  def e
    return if toggle.zero?

    memoized_e
  end

  def memoized_e
    puts 'MEMOIZED'
    100
  end
  strong_memoize_attr :memoized_e
end

obj = Foo.new(0)
puts obj.c # nil
obj.toggle = 1
puts obj.c # "MEMOIZED", memoizes 100
obj.toggle = 0
puts obj.c # nil
obj.toggle = 1
puts obj.c

# obj = Foo.new(0)
# puts obj.d # nil
# obj.toggle = 1
# puts obj.d # nil
# obj.toggle = 0
# puts obj.d # nil

# obj = Foo.new(1)
# puts obj.d # 100
# obj.toggle = 0
# puts obj.d # 100
# obj.toggle = 1
# puts obj.d # 100

obj = Foo.new(0)
puts obj.e # nil
obj.toggle = 1
puts obj.e # "MEMOIZED", memoizes 100
obj.toggle = 0
puts obj.e # nil
obj.toggle = 1
puts obj.e
