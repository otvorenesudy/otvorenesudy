# frozen_string_literal: true

module RankingHelper
  # "3." or, for a shared rank, "3. – 5."
  def rank(data)
    value = data.is_a?(Hash) ? data[:rank] : data

    return ordinalize(number_with_delimiter(value)) unless value.is_a?(Range)

    "#{ordinalize(number_with_delimiter(value.min))} #{t('range.format.delimiter')} " \
      "#{ordinalize(number_with_delimiter(value.max))}"
  end

  def rank_with_order(data, options = {})
    "#{rank(data)} #{options[data.is_a?(Hash) ? data[:order] : :asc]}"
  end
end
