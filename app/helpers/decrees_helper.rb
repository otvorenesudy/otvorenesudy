# frozen_string_literal: true

module DecreesHelper
  UOO_EFFECT_CLASSES = {
    'confirmed' => 'info',
    'approved' => 'info',
    'no_change' => 'info',
    'appeal_rejected' => 'info',
    'appeal_dismissed' => 'info',
    'cancelled' => 'danger',
    'partially_cancelled' => 'danger',
    'changed' => 'warning',
    'partially_changed' => 'warning',
    'remanded' => 'warning'
  }.freeze

  def decree_title(decree)
    title(*decree_identifiers(decree), t('decrees.common.decree'))
  end

  def decree_headline(decree, options = {})
    join_and_truncate decree_identifiers(decree), options.reverse_merge(separator: ' &ndash; ')
  end

  def decree_natures(decree, options = {})
    join_and_truncate decree.natures.map(&:value).sort, options.reverse_merge(separator: ', ')
  end

  def decree_date(date, options = {})
    time_tag date, { format: :long }.merge(options)
  end

  def uoo_decree_effect_badge_class(effect)
    UOO_EFFECT_CLASSES.fetch(effect, 'secondary')
  end

  # A party of a Whistleblower Protection Office decision, linked to the court decrees naming it.
  def link_to_uoo_party(name)
    data = { controller: 'tooltip', bs_toggle: 'tooltip', bs_placement: 'bottom',
             bs_title: t('decrees.uoo.search_party_tooltip') }

    link_to name, decrees_path(q: name), data:
  end

  private

  def decree_identifiers(decree)
    [decree.form, *decree.legislation_subareas].compact.map(&:value).compact_blank
  end
end
