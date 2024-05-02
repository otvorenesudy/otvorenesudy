module ProceedingsHelper
  def proceeding_title(proceeding)
    title(*proceeding_identifiers(proceeding) << t('proceedings.common.proceeding'))
  end

  def proceeding_headline(proceeding, options = {})
    join_and_truncate proceeding_identifiers(proceeding), options.reverse_merge(separator: ' &ndash; ')
  end

  def proceeding_subject(proceeding, options = {})
    join_and_truncate proceeding.legislation_areas_and_subareas.map(&:value),
                      options.reverse_merge(separator: ' &ndash; ')
  end

  def proceeding_date(date, options = {}, &block)
    time_tag date.to_date, { format: :long }.merge(options), &block
  end

  private

  def proceeding_identifiers(proceeding)
    proceeding.events.map { |event| "#{event.court.acronym} #{event.case_number}" }.uniq
  end
end
