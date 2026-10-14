# frozen_string_literal: true

module ProceedingsHelper
  # Where the hearings and decrees of proceedings come from.
  MINISTRY_URL = 'https://www.justice.gov.sk'

  def proceeding_title(proceeding)
    title(*proceeding_identifiers(proceeding), t('proceedings.common.proceeding'))
  end

  def proceeding_headline(proceeding, options = {})
    join_and_truncate proceeding_identifiers(proceeding), options.reverse_merge(separator: ' &ndash; ')
  end

  def proceeding_subject(proceeding, options = {})
    join_and_truncate proceeding.legislation_areas_and_subareas.map(&:value),
                      options.reverse_merge(separator: ' &ndash; ')
  end

  def proceeding_date(date, options = {}, &)
    time_tag date.to_date, { format: :long }.merge(options), &
  end

  private

  # "OSKE1 1C/1/2026": the court's acronym and the case number of each event.
  def proceeding_identifiers(proceeding)
    proceeding.events.map { |event| [event.court&.acronym, event.case_number].compact.join(' ') }.compact_blank.uniq
  end
end
