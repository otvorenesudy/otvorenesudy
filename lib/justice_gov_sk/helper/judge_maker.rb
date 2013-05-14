module JusticeGovSk
  module Helper
    module JudgeMaker
      def make_judge(uri, source, name)
        judge = judge_by_name_unprocessed_factory.find_or_create(name[:unprocessed])
        
        judge.uri    = uri
        judge.source = source
        
        judge.name             = name[:altogether]
        judge.name_unprocessed = name[:unprocessed]
        
        judge.prefix   = name[:prefix]
        judge.first    = name[:first]
        judge.middle   = name[:middle]
        judge.last     = name[:last]
        judge.suffix   = name[:suffix]
        judge.addition = name[:addition]
        
        judge
      end
      
      def make_judge_position(value)
        unless value.nil?
          judge_position = judge_position_by_value_factory.find_or_create(value)
          
          judge_position.value = value
          
          judge_position
        end
      end
      
      def make_employment(court, judge, position, active, note)
        employment = employment_by_court_id_and_judge_id_factory.find_or_create(court.id, judge.id)
        
        employment.court          = court
        employment.judge          = judge
        employment.judge_position = position
        employment.active         = active
        employment.note           = note
        
        employment
      end
    end
  end
end
