# encoding: utf-8

namespace :stats do 
  task :judge_names => :environment do 
    judges = Judge.group(:first).order("count_all desc").count.to_a
    judges_top = judges[0..20]
    judges_other = judges[21..-1].map { |_,v| v }.inject(:+)
    judges_count = Judge.count
    
    judges_top.each do |k,v| puts "['#{k}', #{(v.to_f).round(2)}]," end
    puts "['Ostatní', #{judges_other}]"
  end

  task :judge_surnames => :environment do 
    judges = Judge.group(:last).order("count_all desc").count.to_a
    judges_top = judges[0..20]
    judges_count = Judge.count

    judges_top.each do |k,v| puts "['#{k}', #{v}]," end
  end

  task :court_employments_county => :environment do
    courts = Court.joins(:employments).group("courts.name").where("courts.name LIKE 'Okresný súd%'").order("count_all desc").count
    courts.each do |k,v| puts "['#{k}', #{v}]," end 
    puts "Count #{Employment.where(:court_id => Court.where("courts.name LIKE 'Okresný súd%'")).count}"
  end


  task :court_employments_region => :environment do
    courts = Court.joins(:employments).group("courts.name").where("courts.name LIKE 'Krajský súd%'").order("count_all desc").count
    courts.each do |k,v| puts "['#{k}', #{v}]," end 
    puts "Count #{Employment.where(:court_id => Court.where("courts.name LIKE 'Krajský súd%'")).count}"
  end

  task :court_employments_all_bar => :environment do
    courts = Court.joins(:employments).group("courts.name").order("count_all desc").count
    courts.each do |k,_| puts "'#{k}'," end 
    courts.each do |_,v| puts "#{v}," end
    puts "Count #{Employment.count}"
  end


  task :court_hearings => :environment do 
    hearing_count = Hearing.count
    courts = Court.joins(:hearings).group("courts.name").order("count_all desc").count
    courts.each do |k,v| puts "['#{k}', #{(v).round(2)}]," end 
  end
  
  task :court_hearings_bar => :environment do 
    hearing_count = Hearing.count
    courts = Court.joins(:hearings).group("courts.name").order("count_all desc").count
    courts.each do |k,_| puts "'#{k}'," end 
    courts.each do |_,v| puts "#{v}," end
  end

  task :judge_hearings_bar_max => :environment do 
    judges = Judge.joins(:hearings).group("judges.name").order("count_all desc").limit(40).count
    judges.each do |k,_| puts "'#{k}'," end
    judges.each do |_,v| puts "#{v}," end
  end
  
  task :judge_hearings_bar_min => :environment do 
    judges = Judge.joins(:hearings).group("judges.name").order("count_all").limit(40).count
    judges.each do |k,_| puts "'#{k}'," end
    judges.each do |_,v| puts "#{v}," end
  end


end
