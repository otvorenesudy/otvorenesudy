module EnumerableHelper
  def self.reload
    # :TODO: Dirty reload hack for models/object that use Resource::Enumberable
    Object.constants.each do |c|
      c = c.to_s.constantize rescue next

      if c.respond_to?(:included_modules) && c.included_modules.include?(Resource::Enumerable)
        Object.send(:remove_const, c.to_s)

        load "#{c.to_s.singularize.underscore}.rb"
      end
    end
  end
end
