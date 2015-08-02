# encoding: utf-8

module ProceedingsHelper
  def proceeding_title(proceeding)
    title(*proceeding_identifiers(proceeding))
  end

  def proceeding_headline(proceeding, options = {})
    join_and_truncate proceeding_identifiers(proceeding), { separator: ' &ndash; ' }.merge(options)
  end

  def proceeding_subject(proceeding, options = {})
    join_and_truncate proceeding.legislation_area_and_subarea.map(&:value), { separator: ' &ndash; ' }.merge(options)
  end

  def proceeding_date(date, options = {})
    time_tag date.to_date, { format: :long }.merge(options)
  end

  def link_to_proceeding(proceeding, body, options = {})
    link_to body, proceeding_path(proceeding), options
  end

  private

  def proceeding_identifiers(proceeding)
    proceeding.events.map { |event| "#{event.court.acronym} #{event.case_number}" }.uniq
  end
end
