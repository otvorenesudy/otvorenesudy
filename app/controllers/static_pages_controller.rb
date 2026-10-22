# frozen_string_literal: true

class StaticPagesController < ApplicationController
  PAGES = %w[about contact copyright faq feedback privacy tos].freeze

  # Searchable models and their documents match.
  HEALTH_MODELS = [Court, Judge, Hearing, Decree].freeze

  def home; end

  def show
    @slug = params[:slug]

    return redirect_to("https://api.otvorenesudy.sk?l=#{I18n.locale}", allow_other_host: true) if @slug == 'api'

    raise ActionController::RoutingError, "No page #{@slug}" unless PAGES.include?(@slug)

    @title = t("static_pages.#{@slug}", default: '')
    @template = "static_pages/content/#{@slug}"
  end

  # Anyone can ask, and the counts read whole tables of the database otvorenesudy-api shares, so they run at most once
  # in 5 minutes.
  def health
    model = Rails.cache.fetch('health/mismatch', expires_in: 5.minutes, race_condition_ttl: 10.seconds) do
      HEALTH_MODELS.find { |candidate| candidate.count != candidate.total }&.name
    end

    return head :no_content unless model

    render status: :unprocessable_content, json: { errors: ["#{model} count does not match"] }
  end
end
