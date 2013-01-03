module JusticeGovSk
  module JudgeMatcher
    include Core::Pluralize
    
    def judges_similar_to(name)
      name = name[:altogether]
      
      print "Matching judges by name #{name} ... "
      
      map = Judge.similar_by_name(name, 0.6)
      
      if map.any?
        exact = map[1]
        
        if exact
          puts "done (exact match)"
          puts judges_matched 1.0, exact
          
          exact.each do |judge|
            yield 1, judge
          end
        else
          puts "done (approximate match)"
          
          map.each do |similarity, judges|
            puts judges_matched similarity, judges
            
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
    
    def judges_matched(similarity, judges)
      "Matched similarity #{similarity} #{judges.map { |judge| judge.name }.join ', '}"
    end
  end
end
