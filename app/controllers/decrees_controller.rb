class DecreesController < SearchController
  def show
    @decree = Decree.find(params[:id])

    @court  = @decree.court
    @judges = @decree.judges.order(:last, :middle, :first)

    @legislations = @decree.legislations.order(:value)

    flash.now[:danger]  << t('decrees.show.unprocessed') if @decree.unprocessed?
    flash.now[:danger]  << t('decrees.show.future_date') if @decree.has_future_date?
    flash.now[:warning] << t('decrees.show.faulty_date') if @decree.had_future_date?
  end

  def resource
    @decree = Decree.find(params[:id])

    send_file_in @decree.resource_path, type: 'text/plain'
  end

  def document
    @decree = Decree.find(params[:id])

    return redirect_to @decree.pdf_uri if @decree.pdf_uri

    send_file_in @decree.document_path, name: t('decrees.document.file', ecli: @decree.ecli)
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
