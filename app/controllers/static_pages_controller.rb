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

  def health
    model = HEALTH_MODELS.find { |candidate| candidate.count != candidate.total }

    return head :no_content unless model

    render status: :unprocessable_content, json: { errors: ["#{model} count does not match"] }
  end
end
