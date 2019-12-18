class FixAnonymizedNames < ActiveRecord::Migration
  def up
    classes = [Defendant, Proposer, Opponent]

    classes.each do |c|
      c.where("name ~ '^\\[\"'").find_each do |e|
        e.name = e.name.scan(/([A-Z])+/).flatten.map { |e| "#{e}. " }.join.strip

        e.save!
      end
    end
  end
end
