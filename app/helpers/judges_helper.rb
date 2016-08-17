module JudgesHelper
  def judge_titles(judge, options = {})
    content_tag :span, "#{judge.prefix} #{judge.suffix}".strip, judge_activity_options(judge, options)
  end

  # TODO rm - not really needed, present in _judges and _judge_list use (improve) judge_position_by_employment instead
  # def judge_position(employment, options = {})
  #
  #   # TODO refactor
  #   classes = employment.active ? {} : { class: 'text-muted' }
  #
  #   if employment.judge_position
  #     value = truncate judge_position_by_employment(employment), length: 30, separator: ' ', omission: '&hellip;'
  #
  #     tooltip_tag value.html_safe, employment.active ? I18n.t('judges.active') : I18n.t('judges.inactive'), options.merge(classes)
  #   else
  #     if employment.judge.probably_higher_court_official?
  #       content_tag :span, classes do
  #         (I18n.t('judges.most_likely') + tooltip_tag(I18n.t('judges.vsu_acro'), I18n.t('judges.vsu'), options)).html_safe
  #       end
  #     else
  #       content_tag :span, I18n.t('judges.unknown_2'), classes
  #     end
  #   end
  # end

  # TODO rm - used only once
  # def judge_designation_date_tag(designation)
  #   tooltip_tag icon_tag(:calendar), localize(designation.date, format: :long), placement: :left, class: :undecorated
  # end

  # TODO rm - used only once
  # def judge_designation_date_distance(designation)
  #   tooltip_tag distance_of_time_in_words_to_now(designation.date), localize(designation.date, format: :long)
  # end

  def judge_activity_icon_tag(judge, active, options = {})
    icon, translation = case active
    when true  then %w(checkmark-outline judges.activity.active)
    when false then %w(circle-outline    judges.activity.inactive)
    when nil   then %w(help-outline      judges.activity.unknown)
    end

    options = options.merge class: Array.wrap(options[:class]) << 'text-muted text-undecorated'
    options = options.merge placement: options.delete(:placement) || 'left'

    tooltip_tag icon_tag(icon), t("#{translation}.#{judge.probable_gender}").upcase_first, options
  end

  def judge_activity_by_employment(employment)
    t "judges.activity.#{employment.active ? 'active' : 'inactive'}.#{employment.judge.probable_gender}"
  end

  def judge_position_at_court(judge, court)
    judge_position_by_employment judge.employments.at_court(court).first
  end

  def judge_position_by_employment(employment)
    g = employment.judge.probable_gender

    if employment.judge_position
      if employment.judge_position.charged?
        s = t "judges.position.employee.#{g}"
      else
        if employment.judge_position.value == 'sudca'
          s = t "judges.position.judge.#{g}"
        else
          k = %w(chairman vice_chairman).flat_map { |k| %W(judges.position.#{k}.male judges.position.#{k}.female) }
          s = t guess_translation_key(employment.judge_position.value, :sk, k)
        end
      end
    else
      if employment.judge.probably_higher_court_official?
        p, t = t('judges.position.higher_court_official.acronym'), t("judges.position.higher_court_official.#{g}")
        s = t('judges.position.probably') + tooltip_tag(p, t).html_safe
      else
        s = "#{t "judges.position.unknown.#{g}"} #{t "judges.position.employee.#{g}"}"
      end
    end

    employment.active == nil ? s.upcase_first : s
  end

  def judge_hearings_count_by_employment(employment)
    judge_documents_count Hearing, employment
  end

  def judge_decrees_count_by_employment(employment)
    judge_documents_count Decree, employment
  end

  def judge_processed_names(relation)
    Judge::Names.from_unprocessed(relation).sort.to_sentence
  end

  def link_to_judge(judge, options = {})
    link_to judge.name(options.delete(:format)), judge_path(judge), judge_activity_options(judge, options)
  end

  def links_to_judges(judges, options = {})
    judges.map { |judge| link_to_judge(judge, options) }.to_sentence.html_safe
  end

  def link_to_institution(institution, options = {})
    court = Court.where(name: institution).first
    court ? link_to_court(court, options) : institution
  end

  def link_to_related_person(person, options = {})
    person.known_judge? ? link_to_judge(person.to_judge, options) : person.name
  end

  def links_to_related_people(people, options = {})
    people.map { |person| link_to_related_person(person, options) }.to_sentence.html_safe
  end

  private

  def judge_activity_options(judge, options)
    options.merge! class: 'text-muted' if options.delete(:adjust_by_activity) && !judge.active
    options.merge! class: 'text-muted' if options.key?(:adjust_by_activity_at) && !judge.active_at(options.delete :adjust_by_activity_at)
    options
  end

  def judge_documents_count(model, employment)
    count = model.during_employment(employment).exact.size
    value = number_with_delimiter(count)

    return value if employment.active?

    content_tag :span, value, class: 'text-muted'
  end
end
