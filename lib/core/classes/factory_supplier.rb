class FactorySupplier
  include Singleton
  
  def initialize
    @prototypes = {}
    
    set Factory.new(Court) { |uri| Court.find_by_uri(uri) }
    set Factory.new(CourtJurisdiction)
    set Factory.new(CourtOffice)
    set Factory.new(CourtProceedingType)
    set Factory.new(CourtType) { |value| CourtType.find_by_value(value) }
    
    set Factory.new(Employment)
    
    set Factory.new(Judge) { |name| Judge.find_by_name(name) }
    set Factory.new(JudgePosition) { |value| JudgePosition.find_by_value(value) }
    
    set Factory.new(Municipality) { |name| Municipality.find_by_name(name) }
  end

  def get(type)
    raise "Unsupported type #{type}." if @prototypes[type].nil?
    
    factory = @prototypes[type].clone
    factory
  end
  
  private
  
  def set(factory)
    @prototypes[factory.type] = factory
  end
end