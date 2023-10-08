class Foo
  @@class_var = 10

  attr_reader :instance_var

  def initialize
    @instance_var = 0
  end

  def increment_instance_var
    @instance_var += 1
  end

  def self.increment_class_instance_var
    self.class_instance_var += 1
  end

  def self.increment_class_var
    self.class_var += 1
  end

  def self.class_instance_var=(val)
    @class_instance_var = val
  end

  def self.class_instance_var
    @class_instance_var ||= 5
  end

  def self.class_var=(val)
    @@class_var = val
  end

  def self.class_var
    @@class_var
  end
end

class Baz < Foo
  def initialize
    super
  end
end

# Think about the consistency of Ruby's object model
Foo.increment_class_instance_var # Incremented to 6
puts Foo.class_instance_var # 6
# Notice how class_instance_var is defined in self.class_instance_var with ||=
# Think about what happens when it's defined outside any method like @@class_var and why that results in nil
puts Baz.class_instance_var # Should still be 5

Foo.increment_class_var # Incremented to 10
puts Foo.class_var # 11
puts Baz.class_var # Should be 11

obj1 = Foo.new
obj2 = Foo.new

obj1.increment_instance_var # Increased to 1
puts obj1.instance_var # 1
puts obj2.instance_var # 0
