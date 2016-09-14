class HearingsController < SearchController
  def show
    @hearing = Hearing.find(params[:id])

    @type   = @hearing.type
    @court  = @hearing.court
    @judges = @hearing.judges.order(:last, :middle, :first)

    @proposers  = @hearing.proposers.order(:name)
    @opponents  = @hearing.opponents.order(:name)
    @defendants = @hearing.defendants.order(:name)

    flash.now[:danger]  << t('hearings.show.unprocessed') if @hearing.unprocessed?
    flash.now[:danger]  << t('hearings.show.future_date') if @hearing.has_future_date?
    flash.now[:warning] << t('hearings.show.faulty_date') if @hearing.had_future_date?
    flash.now[:warning] << t('hearings.show.anonymized')  if @hearing.anonymized?
  end

  def resource
    @hearing = Hearing.find(params[:id])

    send_file_in @hearing.resource_path, type: 'text/plain'
  end

  protected

  include FileHelper

  private

  def search_associations
    # NOTE do not eager load scoped associations after original associations,
    # e.g. :exact_judges has to go before :judges, otherwise scoped association will not be loaded
    [:form, :subject, :exact_judges, :inexact_judgings, :judges, :opponents, :proposers, :defendants, :court]
  end
end
