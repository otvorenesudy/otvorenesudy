# encoding: utf-8

module HearingsHelper
  def hearing_title(hearing)
    title(*hearing_identifiers(hearing) << hearing_type(hearing.type))
  end

  def hearing_headline(hearing, options = {})
    join_and_truncate hearing_identifiers(hearing), { separator: ' &ndash; ' }.merge(options)
  end

  def hearing_type(type)
    if type == HearingType.special
      "Pojednávanie Špecializovaného trestného súdu"
    else
      "#{type.value.to_s.upcase_first} súdne pojednávanie"
    end
  end

  def hearing_date(date, options = {})
    date = date.to_date if date.respond_to?(:hour) && date.hour == 0

    time_tag date, { format: :long }.merge(options)
  end

  def link_to_hearing(hearing, body, options = {})
    link_to body, hearing_path(hearing), options
  end

  def link_to_hearing_resource(hearing, body, options = {})
    external_link_to body, "#{hearing_path hearing}/resource", options
  end

  private

  def hearing_identifiers(hearing)
    [hearing.form, hearing.subject].reject(&:blank?).map(&:value)
  end
end
