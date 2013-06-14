# encoding: utf-8

module HearingsHelper
  def hearing_title(hearing)
    options     = { separator: ' &middot; ', tooltip: false }
    identifiers = join_and_truncate hearing_identifiers(hearing), options.dup
    
    "#{identifiers}#{options[:separator]}#{hearing_type hearing.type}".html_safe
  end
  
  def hearing_headline(hearing)
    join_and_truncate hearing_identifiers(hearing), separator: ' &ndash; ', tooltip: true
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
    link_to body, hearing_path(hearing.id), options
  end
  
  def link_to_hearing_resource(hearing, body, options = {})
    link_to body, "#{hearing_path hearing}/resource", { target: :_blank }.merge(options)
  end
  
  private
  
  def hearing_identifiers(hearing)
    [hearing.form, hearing.subject].reject(&:blank?).map(&:value)
  end
end
