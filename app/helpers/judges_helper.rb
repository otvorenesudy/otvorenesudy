# frozen_string_literal: true

module JudgesHelper
  ACTIVITY_ICONS = {
    true => %w[check text-success active],
    false => %w[times text-danger inactive],
    nil => %w[question text-warning unknown]
  }.freeze

  POSITIONS = {
    'sudca' => :judge,
    'hosťujúci sudca' => :visiting_judge,
    'predseda súdnej rady' => :judicial_council_chairman,
    'člen súdnej rady' => :judicial_council_member
  }.freeze

  CHAIR_POSITION_KEYS = %w[chairman vice_chairman].flat_map do |position|
    %W[judges.position.#{position}.male judges.position.#{position}.female]
  end.freeze

  def judge_title(judge, options = {}, &)
    judge_wrap "#{judge.prefix} #{judge.suffix}".strip, judge_activity_options(judge, options), &
  end

  def judge_activity_icon_tag(judge, active, options = {})
    icon, color, activity = ACTIVITY_ICONS.fetch(active)
    size = options.delete(:size)
    options = options.merge(class: Array.wrap(options[:class]).unshift("d-inline #{color}"),
                            placement: options[:placement] || 'top')

    tooltip_tag icon_tag(icon, size:), t("judges.activity.#{activity}.#{judge.probable_gender}").upcase_first, options
  end

  def judge_activity_by_employment(employment, options = {}, &)
    activity = ACTIVITY_ICONS.fetch(employment.active).last
    content = t("judges.activity.#{activity}.#{employment.judge.probable_gender}")

    judge_wrap content, judge_activity_options(employment.judge, options), &
  end

  def judge_position_at_court(judge, court, options = {}, &)
    judge_position_by_employment judge.employments.at_court(court).first, options, &
  end

  def judge_position_by_employment(employment, options = {}, &)
    options = judge_activity_options(employment.judge, options)
    gender = employment.judge.probable_gender

    content =
      if employment.judge_position
        judge_position_name(employment.judge_position, gender)
      elsif employment.judge.probably_higher_court_official?
        judge_probable_higher_court_official(gender, muted: options[:class]&.include?('text-muted'))
      else
        "#{t("judges.position.unknown.#{gender}")} #{t("judges.position.employee.#{gender}")}"
      end

    judge_wrap content, options, &
  end

  def judge_hearings_count_by_employment(employment, options = {}, &)
    count = number_with_delimiter Hearing.during_employment(employment).exact.size

    judge_wrap count, judge_activity_options(employment.judge, options), &
  end

  def judge_decrees_count_by_employment(employment, options = {}, &)
    count = number_with_delimiter Decree.during_employment(employment).exact.size

    judge_wrap count, judge_activity_options(employment.judge, options), &
  end

  def judge_processed_names(*relations)
    relations.flat_map { |relation| Judge::Names.from_unprocessed(relation) }.uniq.sort.to_sentence
  end

  def link_to_judge(judge, options = {})
    link_to judge.name(options.delete(:format)), judge, judge_activity_options(judge, options)
  end

  def links_to_judges(judges, options = {})
    to_sentence(judges.map { |judge| link_to_judge(judge, options) })
  end

  def link_to_related_person(person, options = {})
    person.known_judge? ? link_to_judge(person.to_judge, options) : person.name
  end

  private

  def judge_position_name(position, gender)
    return t("judges.position.employee.#{gender}") if position.charged?

    name = POSITIONS[position.value]
    return t("judges.position.#{name}.#{gender}") if name

    key = guess_translation_key(position.value, :sk, CHAIR_POSITION_KEYS)
    key ? t(key) : position.value
  end

  # "pravdepodobne VSÚ", the acronym explained in a tooltip.
  def judge_probable_higher_court_official(gender, muted:)
    name = t("judges.position.higher_court_official.#{gender}")
    acronym = t('judges.position.higher_court_official.acronym')

    safe_join([t('judges.position.probably'), tooltip_tag(acronym, name.upcase_first, class: ('text-muted' if muted))],
              ' ')
  end

  # Muted (text-muted) when the judge is inactive anywhere (mute_by_activity), at a court (mute_by_activity_at) or in
  # an employment (mute_by_activity_on).
  def judge_activity_options(judge, options)
    options = options.dup
    anywhere = options.delete(:mute_by_activity)
    court = options.delete(:mute_by_activity_at)
    employment = options.delete(:mute_by_activity_on)

    muted = (anywhere && !judge.active) || (court && !judge.active_at(court)) || (employment && !employment.active)
    classes = Array.wrap(options[:class])
    classes += ['text-muted'] if muted

    options.merge(class: classes.presence)
  end

  def judge_wrap(content, options)
    content = yield content if block_given?

    %i[id class data].any? { |key| options[key].present? } ? tag.span(content, **options) : content
  end
end
