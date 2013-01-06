module JusticeGovSk
  module Helper
    module JudgeMatcher
      include Core::Pluralize
      
      def match_judges_by(name)
        name = name[:altogether]
        
        print "Matching judges by name #{name} ... "
        
        map = Judge.similar_by_name(name, 0.55)
        
        if map.any?
          exact = map[1.0]
          
          if exact
            puts "done (exact match)"
            puts matched_judges 1.0, exact
            
            exact.each do |judge|
              yield 1.0, judge
            end
          else
            puts "done (approximate match)"
  
            map.each do |similarity, judges|
              puts matched_judges similarity, judges
            end
            
            map.each do |similarity, judges|
              judges.each do |judge|
                yield similarity, judge
              end
            end
          end
        else
          puts "failed (no match)"
          
          raise "Unable to find judge similar to #{name}"
        end
      end
      
      private
      
      def matched_judges(similarity, judges)
        "Matched with similarity #{similarity} #{judges.map { |judge| judge.name }.join ', '}"
      end
    end
  end
end
