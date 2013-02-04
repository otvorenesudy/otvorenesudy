# encoding: utf-8

module HearingsHelper
  def hearing_type(type)
    if type == HearingType.special
      "Pojednávanie Špecializovaného trestného súdu"
    else
      "#{type.value.to_s.upcase_first} súdne pojednávanie"
    end  
  end
  
  def hearing_date(date)
    date = date.to_date if date.hour == 0
    
    time_tag date, format: :long 
  end
  
  def link_to_hearing(hearing, options = {})
    link_to hearing.name, hearing_path(hearing.id), options
  end
end
