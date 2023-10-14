class Foo
  attr_accessor :bar
  def initialize(bar: {})
    @bar = bar
  end
end

a = Foo.new(bar: { baz: 'qux' })
puts a.bar
