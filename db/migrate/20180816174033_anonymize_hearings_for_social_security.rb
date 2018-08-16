class AnonymizeHearingsForSocialSecurity < ActiveRecord::Migration
  def up
    hearing_ids = []

    Defendant.select('id, name, hearing_id').find_each do |e|
      hearing_ids << e.hearing_id if ActiveSupport::Inflector.transliterate(e.name).downcase.match(/socialna\s+poistovna/)
    end

    Opponent.select('id, name, hearing_id').find_each do |e|
      hearing_ids << e.hearing_id if ActiveSupport::Inflector.transliterate(e.name).downcase.match(/socialna\s+poistovna/)
    end

    Proposer.select('id, name, hearing_id').find_each do |e|
      hearing_ids << e.hearing_id if ActiveSupport::Inflector.transliterate(e.name).downcase.match(/socialna\s+poistovna/)
    end

    Hearing.where(id: hearing_ids).anonymize!
    Hearing.where(anonymized: true).anonymize!
  end

  def down; end
end
