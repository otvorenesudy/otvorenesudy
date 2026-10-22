# frozen_string_literal: true

class DecreesController < SearchController
  before_action :set_decree, only: %i[show document]

  def show
    @highlights = params[:h].to_s
    @similar = @decree.similar

    @court = @decree.court
    @judges = @decree.judges.order(:last, :middle, :first)
    @legislations = @decree.legislations.order(:value)

    warn_about_data
  end

  def uoo
    @uoo_source_url = Uoo::Data.source_url
    @uoo_decrees = Uoo::Data.all
    @uoo_stats = Uoo::Data.stats
  end

  # The decree's PDF from its source, for the viewer on the decree's page, which can't read it across origins.
  def document
    return head :not_found if @decree.pdf_uri.blank?

    pdf = DecreeDocument.fetch(@decree.pdf_uri)

    send_data pdf, type: 'application/pdf', filename: "Otvorené Súdy — Rozhodnutie — ##{@decree.id}.pdf"
  rescue DecreeDocument::Busy
    head :service_unavailable
  rescue DecreeDocument::Unavailable => e
    Rails.logger.warn "DecreesController # Document of decree [#{@decree.id}] unavailable: #{e.message}"

    head :bad_gateway
  end

  private

  def set_decree
    @decree = Decree.find(params.expect(:id))
  end

  def warn_about_data
    flash_now(:danger, t('.unprocessed')) if @decree.unprocessed?
    flash_now(:danger, t('.future_date')) if @decree.future_date?
    flash_now(:warning, t('.faulty_date')) if @decree.future_date_when_created?
  end

  # The scoped associations (exact_judges, inexact_judgements) load before the ones they scope (judges).
  def search_associations
    %i[form legislation_areas legislation_subareas natures court exact_judges inexact_judgements judgements judges]
  end
end
