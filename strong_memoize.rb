# frozen_string_literal: true

module StrongMemoize
  def strong_memoize(name)
    key = ivar(name)

    if instance_variable_defined?(key)
      instance_variable_get(key)
    else
      instance_variable_set(key, yield)
    end
  end

  module StrongMemoizeClassMethods
    def strong_memoize_attr(method_name)
      member_name = StrongMemoize.normalize_key(method_name)

      StrongMemoize.send(:do_strong_memoize, self, method_name, member_name) # rubocop:disable GitlabSecurity/PublicSend
    end
  end

  def self.included(base)
    base.singleton_class.prepend(StrongMemoizeClassMethods)
  end

  private

  # Convert `"name"`/`:name` into `:@name`
  #
  # Depending on a type ensure that there's a single memory allocation
  def ivar(name)
    case name
    when Symbol
      name.to_s.prepend("@").to_sym
    when String
      :"@#{name}"
    else
      raise ArgumentError, "Invalid type of '#{name}'"
    end
  end

  class << self
    def normalize_key(key)
      return key unless key.end_with?('!', '?')

      # Replace invalid chars like `!` and `?` with allowed Unicode codeparts.
      key.to_s.tr('!?', "\uFF01\uFF1F")
    end

    private

    def do_strong_memoize(klass, method_name, member_name)
      method = klass.instance_method(method_name)

      unless method.arity == 0
        raise <<~ERROR
          Using `strong_memoize_attr` on methods with parameters is not supported.

          Use `strong_memoize_with` instead.
          See https://docs.gitlab.com/ee/development/utilities.html#strongmemoize
        ERROR
      end

      # Methods defined within a class method are already public by default, so we don't need to
      # explicitly make them public.
      scope = %i[private protected].find do |scope|
        klass.send("#{scope}_instance_methods") # rubocop:disable GitlabSecurity/PublicSend
          .include? method_name
      end

      klass.define_method(method_name) do |&block|
        strong_memoize(member_name) do
          method.bind_call(self, &block)
        end
      end

      klass.send(scope, method_name) if scope # rubocop:disable GitlabSecurity/PublicSend
    end
  end
end
