# frozen_string_literal: true

class JudgesController < SearchController
  INDICATORS = %i[indicators_2013 indicators_2015 indicators_2017 indicators_2021].freeze

  # The years whose indicators compare the judge with others (the 2021 evaluation compares with no one).
  COMPARED_INDICATORS = %i[indicators_2013 indicators_2015 indicators_2017].freeze

  def show
    @judge = Judge.find(params.expect(:id))

    @employments = @judge.employments.includes(:court, :judge_position)
    @designations = @judge.designations.includes(:type).order(date: :desc)

    @historical_hearings = @judge.hearings.historical.exact.order(date: :desc)
    @upcoming_hearings = @judge.hearings.upcoming.exact.order(date: :desc)
    @decrees = @judge.decrees.exact.order(date: :desc)

    @latest_indicators = INDICATORS.rfind { |key| @judge.public_send(key).present? }
    @comparisons = COMPARED_INDICATORS.index_with { |key| compare(key) }

    flash_now(:danger, t('.incomplete')) if @judge.incomplete?
  end

  private

  # Suggestions for the facets that pick judges to compare with a judge (?id=) link to that judge's page.
  def suggest_partial(facet)
    return super if params[:id].blank?

    facet.name == :name ? 'judges/indicators/facets/name_results' : 'judges/indicators/facets/terms_results'
  end

  def search_associations
    [{ employments: %i[court judge judge_position] }]
  end

  def default_sort
    { sort: 'sortable_name', order: 'asc' }
  end

  # The facets to pick other judges with the year's indicators by, and the judges picked.
  def compare(key)
    results = Judge.search(search_params.merge(key => 'true'))
    others = params[:name].present? ? results.records.to_a - [@judge] : []

    Comparison.new(results.facets, others)
  end

  Comparison = Data.define(:facets, :others)
end
