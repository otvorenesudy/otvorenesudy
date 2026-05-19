module DecreesHelper
  def decree_title(decree)
    title(*decree_identifiers(decree) << t('decrees.common.decree'))
  end

  def uoo_decree_effect_badge_class(effect)
    case effect
    when 'confirmed', 'approved', 'no_change', 'appeal_rejected', 'appeal_dismissed'
      'info'
    when 'cancelled', 'partially_cancelled'
      'danger'
    when 'changed', 'partially_changed'
      'warning'
    when 'remanded'
      'warning'
    else
      'secondary'
    end
  end

  def decree_headline(decree, options = {})
    join_and_truncate decree_identifiers(decree), options.reverse_merge(separator: ' &ndash; ')
  end

  def decree_natures(decree, options = {})
    join_and_truncate decree.natures.sort_by(&:value).map(&:value), options.reverse_merge(separator: ', ')
  end

  def decree_date(date, options = {}, &block)
    time_tag date, { format: :long }.merge(options), &block
  end

  private

  def decree_identifiers(decree)
    [decree.form, *decree.legislation_subareas].reject(&:blank?).map(&:value)
  end
end
