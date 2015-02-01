# encoding: utf-8

class JudgesController < SearchController
  include FileHelper

  def index
    @judges = Judge.order(:last, :middle, :first).page(params[:page])
  end

  def show
    @judge = Judge.find(params[:id])

    @employments  = @judge.employments
    @designations = @judge.designations.order('date desc')

    @historical_hearings = @judge.hearings.historical.exact.order('date desc')
    @upcoming_hearings   = @judge.hearings.upcoming.exact.order('date desc')
    @decrees             = @judge.decrees.exact.order('date desc')

    @property_declarations = @judge.property_declarations.order('year desc')
    @statistical_summaries = @judge.statistical_summaries.order('year desc')

    @results = @judge.context_search[0..9]

    search_judges_for_indicators
  end

  def curriculum
    @judge = Judge.find(params[:id])

    send_file_in @judge.curriculum_path, name: "Životopis - #{@judge.name}", escape: false
  end

  def cover_letter
    @judge = Judge.find(params[:id])

    send_file_in @judge.cover_letter_path, name: "Motivačný list - #{@judge.name}", escape: false
  end

  def indicators_suggest
    redirect_to suggest_judges_path(params)
  end

  private

  def search_judges_for_indicators
    results = Judge.search(params.merge!(has_indicators: true))

    @facets = results.facets
    @judges_for_indicators = Hash.new


    if params[:name]
      color = generate_random_color

      results.each do |result|
        color = generate_random_color while @judges_for_indicators[color]

        @judges_for_indicators[color] = result
      end
    end
  end

  def generate_random_color(options = {})
    3.times.map { rand(0..255) }
  end
end
