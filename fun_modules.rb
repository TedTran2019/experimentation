module Module1
  def fun1
    puts 'fun1 from Module1'
  end

  def self.included(_base)
    def fun2
      puts 'fun2 from Module1'
    end
  end

  def self.extended(base)
    # Without an explicit definee, fun3 is defined in the closest lexically enclosing module.
    # self.included and self.extended are callbacks to extend behavior when using include/extend
    # Class methods are just instance methods of the singleton class...
    def base.fun3
      puts 'fun3 from Module1'
    end
  end
end

module Module2
  def foo
    puts 'foo from Module2'
  end

  def self.extended(_base)
    def bar
      puts 'bar from Module2'
    end
  end
end

class Test
  include Module1
  extend Module2
  def abc
    puts 'abc form Test'
  end
end

class Test2
  extend Module1
end

Test.new.abc  #=> abc form Test
Test.new.fun1 #=> fun1 from Module1
Test.new.fun2 #=> fun2 from Module1
Test.foo #=> foo from Module2
Test.bar #=> bar from Module2
# Test.new.fun3 #=> **NoMethodError** (undefined method `fun3' ..)
Test2.fun3 #=> fun3 from Module1

# https://www.youtube.com/watch?v=X2sgQ38UDVY
# https://aaronlasseigne.com/2012/01/17/explaining-include-and-extend/
# Everything in Ruby is an object
# Objects don't store behavior
# Think parents as up, singleton classes to the right
# Include: Simply adds another parent
# Extend: Adds a parent to the singleton class (Essentially just using include on the obj's singleton class)
# Classes are objects too, so "class"/instance methods work the same way
