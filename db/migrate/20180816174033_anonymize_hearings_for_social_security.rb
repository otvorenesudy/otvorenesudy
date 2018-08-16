class AnonymizeHearingsForSocialSecurity < ActiveRecord::Migration
  def up
    Hearing.includes(:defendants, :opponents, :proposers).find_each do |hearing|
      hearing.anonymize if hearing.social_security_case? || hearing.anonymized
    end
  end

  def down; end
end
