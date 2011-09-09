NilClass.class_eval do
  METHOD_CLASS_MAP = Hash.new

  def self.add_whiner(klass)
    methods = klass.public_instance_methods - public_instance_methods
    class_name = klass.name
    methods.each { |method| METHOD_CLASS_MAP[method.to_sym] = class_name }
  end

  add_whiner ::Array

  # Raises a RuntimeError when you attempt to call +id+ on +nil+.
  
  def id
    return 0 if RAILS_ENV == 'production'
    raise RuntimeError, "Called id for nil, which would mistakenly be #{object_id} -- if you really wanted the id of nil, use object_id", caller
  end

  private
    def method_missing(method, *args)
      if method.to_s == 'zero?' then
        return true
      end
      if 1.respond_to? method and args.first.class == Fixnum then
        return 0 if RAILS_ENV == 'production'
      end
      if ''.respond_to? method and args.first.class == String then
        return 'NilString' if RAILS_ENV == 'production'
      end
      if klass = METHOD_CLASS_MAP[method]
        raise_nil_warning_for klass, method, caller
      else
        super
      end
    end

    # Raises a NoMethodError when you attempt to call a method on +nil+.
    def raise_nil_warning_for(class_name = nil, selector = nil, with_caller = nil)
      message = "You have a nil object when you didn't expect it!"
      message << "\nYou might have expected an instance of #{class_name}." if class_name
      message << "\nThe error occurred while evaluating nil.#{selector}" if selector

      raise NoMethodError, message, with_caller || caller
    end
end
