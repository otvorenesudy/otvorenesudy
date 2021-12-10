class DecreesController < SearchController
  def show
    @decree = Decree.find(params[:id])
    @highlights = params[:h]

    @court  = @decree.court
    @judges = @decree.judges.order(:last, :middle, :first)

    @legislations = @decree.legislations.order(:value)

    flash.now[:danger]  << t('decrees.show.unprocessed') if @decree.unprocessed?
    flash.now[:danger]  << t('decrees.show.future_date') if @decree.has_future_date?
    flash.now[:warning] << t('decrees.show.faulty_date') if @decree.had_future_date?
  end

  def document
    @decree = Decree.find(params[:id])

    @file = Tempfile.new('decree', binmode: true)
    curl = Curl.get(@decree.pdf_uri)

    curl.perform

    @file.write(curl.body_str)
    @file.rewind

    send_file @file, filename: "Otvorené Súdy — Rozhodnutie — ##{@decree.id}.pdf"
  end

  protected

  include FileHelper

  private

  def search_associations
    # NOTE do not eager load scoped associations after original associations,
    # e.g. :exact_judges has to go before :judges, otherwise scoped association will not be loaded
    [:form, :legislation_area, :legislation_subarea, :natures, :court, :exact_judges, :inexact_judgements, :judgements, :judges]
  end
end
