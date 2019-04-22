module CourtsHelper
  def link_to_court(court, options = {})
    link_to court.name, court_path(court), options
  end

  def links_to_courts(courts, options = {})
    courts.map { |court| link_to_court(court, options) }.to_sentence.html_safe
  end

  def link_to_court_by_judge_employment(employment, options = {})
    link_to_court employment.court, judge_activity_options(employment.judge, options)
  end

  def link_to_institution(institution, options = {})
    court = Court.where(name: institution).first
    court ? link_to_court(court, options) : institution
  end
end
