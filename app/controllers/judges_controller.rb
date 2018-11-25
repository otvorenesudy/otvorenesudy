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
    @media = [] # @judge.context_search[0..9]

    flash.now[:danger] << t('judges.show.incomplete') if @judge.incomplete?

    keys = [:indicators_2013, :indicators_2015, :indicators_2017]
    results_2013 = Judge.search(params.except(*keys).merge(indicators_2013: true))
    @facets_2013 = results_2013.facets
    @others_2013 = params[:name] ? results_2013.to_a.map(&:first) : []

    results_2015 = Judge.search(params.except(*keys).merge(indicators_2015: true))
    @facets_2015 = results_2015.facets
    @others_2015 = params[:name] ? results_2015.to_a.map(&:first) : []

    results_2017 = Judge.search(params.except(*keys).merge(indicators_2017: true))
    @facets_2017 = results_2017.facets
    @others_2017 = params[:name] ? results_2017.to_a.map(&:first) : []
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
end
