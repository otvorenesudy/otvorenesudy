# frozen_string_literal: true

# Replaces a hearing's party names with random initials ("J. N."), unique within each kind of party, reindexes the
# hearing and its proceeding, and marks the hearing anonymized.
class HearingAnonymizer
  PARTIES = %i[proposers opponents defendants].freeze

  attr_reader :hearing

  def initialize(hearing)
    @hearing = hearing
  end

  def anonymize!(parties = PARTIES)
    Hearing.transaction do
      (PARTIES & parties).each { |party| anonymize_party(hearing.public_send(party)) }

      hearing.save!
      hearing.update_column(:anonymized_at, hearing.updated_at) # rubocop:disable Rails/SkipsModelValidations
    end

    hearing.proceeding&.update_index
    hearing.reload
  end

  private

  def anonymize_party(association)
    association.find_each do |person|
      name = initials while name.nil? || association.where.not(id: person.id).exists?(name:)

      person.update!(name:, name_unprocessed: name)
    end
  end

  def initials
    ('A'..'Z').to_a.sample(2).map { |letter| "#{letter}." }.join(' ')
  end
end
