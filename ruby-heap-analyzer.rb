require 'json'

class Analyzer
  def initialize(filename)
    @filename = filename
  end

  def file(&block)
    File.open(@filename, &block)
  end

  def analyze_generations
    data = Array.new

    file do |f|
      f.each_line do |line|
        data << JSON.parse(line)
      end
    end

    data
      .group_by { |row| row['generation'] }
      .sort { |a,b| a[0].to_i <=> b[0].to_i }
      .each { |k,v| puts "generation #{k} objects #{v.count}" }
  end

  def analyze_generation(generation)
    data = []

    file do |f|
      f.each_line do |line|
        parsed=JSON.parse(line)
        data << parsed if parsed['generation'] == generation.to_i
      end
    end

    data
      .group_by { |row| "#{row["file"]}:#{row["line"]}" }
      .sort{ |a,b| b[1].count <=> a[1].count }
      .each { |k,v| puts "#{k} * #{v.count}" }
  end
end

case ARGV[1]
when 'generations' then Analyzer.new(ARGV[0]).analyze_generations
when 'generation'  then Analyzer.new(ARGV[0]).analyze_generation(ARGV[2])
end
