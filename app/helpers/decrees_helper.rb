module DecreesHelper
  def decree_title(decree)
    title(*decree_identifiers(decree) << t('decrees.common.decree'))
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
    [decree.form, decree.legislation_subarea].reject(&:blank?).map(&:value)
  end
end
