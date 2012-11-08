class FactorySupplier
  include Singleton
  
  def initialize
    @prototypes = {}
    
    set Factory.new(Accusation) { |defendant_id, value| Defendant.find_by_defendant_id_and_value(defendant_id, value) }

    set Factory.new(Court) { |uri| Court.find_by_uri(uri) }
    set Factory.new(CourtJurisdiction)
    set Factory.new(CourtOffice)
    set Factory.new(CourtProceedingType)
    set Factory.new(CourtType) { |value| CourtType.find_by_value(value) }

    set Factory.new(Decree) { |uri| Decree.find_by_uri(uri) }
    set Factory.new(DecreeForm) { |value| DecreeForm.find_by_value(value) }
    set Factory.new(DecreeNature) { |value| DecreeNature.find_by_value(value) }

    set Factory.new(Defendant) { |hearing_id, name| Defendant.find_by_hearing_id_and_name(hearing_id, name) }
    
    set Factory.new(Employment)

    set Factory.new(Hearing) { |uri| Hearing.find_by_uri(uri) }
    set Factory.new(HearingForm) { |value| HearingForm.find_by_value(value) }
    set Factory.new(HearingSection) { |value| HearingSection.find_by_value(value) }
    set Factory.new(HearingSubject) { |value| HearingSubject.find_by_value(value) }
    set Factory.new(HearingType) { |value| HearingType.find_by_value(value) }
    
    set Factory.new(Judge) { |name| Judge.find_by_name(name) }
    set Factory.new(JudgePosition) { |value| JudgePosition.find_by_value(value) }
    set Factory.new(Judging) { |judge_id, hearing_id| Judging.find_by_judge_id_and_hearing_id(judge_id, hearing_id) }
    
    set Factory.new(Legislation) { |value| Legislation.find_by_value(value) }
    set Factory.new(LegislationArea) { |value| LegislationArea.find_by_value(value) }
    set Factory.new(LegislationSubarea) { |value| LegislationSubarea.find_by_value(value) }
    set Factory.new(LegislationUsage) { |legislation_id, decree_id| LegislationUsage.find_by_legislation_id_and_decree_id(legislation_id, decree_id) }

    set Factory.new(Municipality) { |name| Municipality.find_by_name(name) }

    set Factory.new(Opponent) { |hearing_id, name| Opponent.find_by_hearing_id_and_name(hearing_id, name) }
    
    set Factory.new(Proceeding)

    set Factory.new(Proposer) { |hearing_id, name| Proposer.find_by_hearing_id_and_name(hearing_id, name) }
  end

  def get(type, find = nil)
    raise "Unsupported type #{type}." if @prototypes[type].nil?
    
    unless find.nil?
      @prototypes[type].class.new(type) { |*args| type.send(find, *args) }
    else
      @prototypes[type].clone
    end
  end
  
  private
  
  def set(factory)
    @prototypes[factory.type] = factory
  end
end