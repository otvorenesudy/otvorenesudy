# encoding: utf-8

module JudgesHelper
  include Judges::IndicatorsHelper

  def judge_titles(judge, options = {})
    content_tag :span, "#{judge.prefix} #{judge.suffix}".strip, judge_options(judge, options)
  end

  def judge_activity(status)
    return I18n.t('judges.active')   if status == true
    return I18n.t('judges.inactive') if status == false
    return I18n.t('judges.unknown')   if status == nil
    raise
  end

  def judge_activity_gender(active, is_woman)
    if active
      if I18n.locale == :sk
        I18n.t('judges.active_gender') + (is_woman ? 'a' : 'y')
      else
        I18n.t('judges.active')
      end
    else
      if I18n.locale == :sk
        I18n.t('judges.inactive_gender') + (is_woman ? 'a' : 'y')
      else
        I18n.t('judges.inactive')
      end
    end
  end

  def judge_employment_active(active, is_woman)
    # if I18n.locale == :sk
    #   (active == nil ? 'P' : 'p') + (is_woman ? 'pracovníčka' : 'pracovník')

    # @judge.probably_woman? && employment.judge_position.value == 'sudca' ? 'sudkyňa' : employment.judge_position.value

    # if @judge.probably_superior_court_officer?
    #   employment.active == nil ? 'P' : 'p' %>ravdepodobne <%= tooltip_tag "VSÚ", "Vyšší súdny úradník"
    # else
    #   employment.active == nil ? 'N' : 'n' %>eznám<%= @judge.probably_woman ? 'a pracovníčka' : 'y pracovník'
    # end
  end

  def judge_activity_icon_tag(status)
    return icon_tag(:'ok-sign')      if status == true
    return icon_tag(:'circle-blank') if status == false
    return icon_tag(:question)       if status == nil
    raise
  end

  def judge_activity_tag(status, options = {})
    options  = { tooltip: true }.merge options
    icon_tag = judge_activity_icon_tag(status)
    activity = judge_activity(status)

    return icon_tag unless options.delete(:tooltip)

    options[:placement] ||= :left

    tooltip_tag icon_tag, activity, options.merge(class: :undecorated)
  end

  def judge_position(employment, options = {})
    classes = employment.active ? {} : { class: :muted }

    if employment.judge_position
      value = truncate employment.judge_position.value, length: 30, separator: ' ', omission: '&hellip;'

      tooltip_tag value.html_safe, employment.active ? I18n.t('judges.active') : I18n.t('judges.inactive'), options.merge(classes)
    else
      if employment.judge.probably_superior_court_officer?
        content_tag :span, classes do
          (I18n.t('judges.most_likely') + tooltip_tag(I18n.t('judges.vsu_acro'), I18n.t('judges.vsu'), options)).html_safe
        end
      else
        content_tag :span, I18n.t('judges.unknown_2'), classes
      end
    end
  end

  def judge_at_court_employment(judge, court)
    judge.employments.at_court(court).first
  end

  def judge_at_court_position(judge, court)
    judge_at_court_employment(judge, court).judge_position.value
  end

  def judge_hearings_count_by_employment(employment)
    judge_documents_count_by_employment Hearing, employment
  end

  def judge_decrees_count_by_employment(employment)
    judge_documents_count_by_employment Decree, employment
  end

  def judge_designation_date_tag(designation)
    tooltip_tag icon_tag(:calendar), localize(designation.date, format: :long), placement: :left, class: :undecorated
  end

  def judge_designation_date_distance(designation)
    tooltip_tag distance_of_time_in_words_to_now(designation.date), localize(designation.date, format: :long)
  end

  def judge_processed_names(relation)
    Judge::Names.from_unprocessed(relation).sort.to_sentence
  end

  def link_to_judge(judge, options = {})
    link_to judge.name(options.delete(:format)), judge_path(judge), judge_options(judge, options)
  end

  def links_to_judges(judges, options = {})
    judges.map { |judge| link_to_judge(judge, options) }.to_sentence.html_safe
  end

  def link_to_institution(institution, options = {})
    court = Court.where(name: institution).first

    return link_to_court(court, options) if court

    institution
  end

  def link_to_related_person(person, options = {})
    return link_to_judge(person.to_judge, options) if person.known_judge?

    person.name
  end

  def links_to_related_people(people, options = {})
    people.map { |person| link_to_related_person(person, options) }.to_sentence.html_safe
  end

  private

  def judge_documents_count_by_employment(model, employment)
    count = model.during_employment(employment).exact.size
    value = number_with_delimiter(count)

    return value if employment.active?

    content_tag :span, value, class: :muted
  end

  def judge_options(judge, options)
    options.merge! judge.active ? {} : { class: :muted } if options.delete :adjust_by_activity
    options.merge! judge.active_at(options.delete :adjust_by_activity_at) ? {} : { class: :muted } if options.key? :adjust_by_activity_at
    options
  end
end
