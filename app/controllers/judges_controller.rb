class JudgesController < SearchController
  def show
    @judge = Judge.find(params[:id])

    @employments  = @judge.employments
    @designations = @judge.designations.order('date desc')

    @historical_hearings = @judge.hearings.historical.exact.order('date desc')
    @upcoming_hearings   = @judge.hearings.upcoming.exact.order('date desc')
    @decrees             = @judge.decrees.exact.order('date desc')

    @property_declarations = @judge.property_declarations.order('year desc')
    @statistical_summaries = @judge.statistical_summaries.order('year desc')

    # TODO rm or fix Bing Search API
    # @media = [] # @judge.context_search[0..9]

    flash.now[:danger] << t('judges.show.incomplete') if @judge.incomplete?

    # TODO rm: after this there are still both 2013 and 2017 suffixed fields in query, why?
    # @available_indicators = {
    #   indicators_2017: @judge.indicators_2017.present?,
    #   indicators_2015: @judge.indicators_2015.present?,
    #   indicators_2013: @judge.indicators_2013.present?
    # }
    #
    # @indicators = (
    #   params.slice(:indicators_2017, :indicators_2015, :indicators_2013).keys.first&.to_sym ||
    #   @available_indicators.find { |(name, available)| available }&.first ||
    #   :indicators_2017
    # )
    #
    # params[@indicators] = true unless params[@indicators].present?
    #
    # results = Judge.search(params)
    # @facets = results.facets
    # @others = params[:name] ? results.to_a.map(&:first) : []

    # TODO this searches through first available indicators only! it leaves others as blank so later
    # when we figure out how to search through desired available indicators we do not have to change views
    keys = [:indicators_2013, :indicators_2015, :indicators_2017, :indicators_2021]

    @latest_indicators = keys.reverse.find { |key| @judge.send(key).present? }

    @facets_2013, @others_2013 = search_indicators(:indicators_2013)
    @facets_2015, @others_2015 = search_indicators(:indicators_2015)
    @facets_2017, @others_2017 = search_indicators(:indicators_2017)
  end

  # TODO rm - unused?
  # def curriculum
  #   @judge = Judge.find(params[:id])
  #
  # TODO translate
  #   send_file_in @judge.curriculum_path, name: "Životopis - #{@judge.name}", escape: false
  # end

  # TODO rm - unused?
  # def cover_letter
  #   @judge = Judge.find(params[:id])
  #
  # TODO translate
  #   send_file_in @judge.cover_letter_path, name: "Motivačný list - #{@judge.name}", escape: false
  # end

  protected

  include FileHelper

  private

  def search_associations
    [employments: [:court, :judge, :judge_position]]
  end

  def search_indicators(key)
    return if key != @latest_indicators
    results = Judge.search(params.merge(@latest_indicators => true))
    [results.facets, params[:name] ? results.to_a.map(&:first) : []]
  end
end
