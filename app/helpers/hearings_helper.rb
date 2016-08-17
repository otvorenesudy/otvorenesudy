module HearingsHelper
  def hearing_title(hearing)
    title(*hearing_identifiers(hearing) << hearing_type(hearing.type))
  end

  def hearing_headline(hearing, options = {})
    join_and_truncate hearing_identifiers(hearing), { separator: ', ' }.merge(options)
  end

  def hearing_type(type)
    case type
    when HearingType.civil    then "#{t 'hearings.type.civil'} #{t 'hearing.one'}"
    when HearingType.criminal then "#{t 'hearings.type.criminal'} #{t 'hearing.one'}"
    when HearingType.special  then "#{t('hearing.one').upcase_first} #{t('hearings.type.special').downcase_first}"
    else
      raise
    end
  end

  def hearing_date(date, options = {}, &block)
    date = date.to_date if date.respond_to?(:hour) && date.hour.zero?

    time_tag date.to_date, { format: :long }.merge(options), &block
  end

  def link_to_hearing(hearing, body, options = {})
    link_to body, hearing_path(hearing), options
  end

  def link_to_hearing_resource(hearing, body, options = {})
    external_link_to body, resource_hearing_path(hearing), options
  end

  private

  def hearing_identifiers(hearing)
    [hearing.form, hearing.subject].reject(&:blank?).map(&:value)
  end
end
