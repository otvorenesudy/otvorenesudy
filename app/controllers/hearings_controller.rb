class HearingsController < SearchController
  before_filter :initialize_flash_as_arrays

  def show
    @hearing = Hearing.find(params[:id])

    @type   = @hearing.type
    @court  = @hearing.court
    @judges = @hearing.judges.order(:last, :middle, :first)

    @proposers  = @hearing.proposers.order(:name)
    @opponents  = @hearing.opponents.order(:name)
    @defendants = @hearing.defendants.order(:name)

    flash.now[:error]  << render_to_string(partial: 'unprocessed',     locals: { hearing: @hearing }).html_safe if @hearing.unprocessed?
    flash.now[:error]  << render_to_string(partial: 'has_future_date', locals: { hearing: @hearing }).html_safe if @hearing.has_future_date?
    flash.now[:notice] << render_to_string(partial: 'had_future_date', locals: { hearing: @hearing }).html_safe if @hearing.had_future_date?
    flash.now[:notice] << render_to_string(partial: 'anonymized',      locals: { hearing: @hearing }).html_safe if @hearing.anonymized?
  end

  def resource
    @hearing = Hearing.find(params[:id])

    send_file_in @hearing.resource_path, type: 'text/plain'
  end

  protected

  include FileHelper
  include FlashHelper

  private

  def search_associations
    # NOTE do not eagerload scoped associations after original associations!
    # e.g. :exact_judges has to go before :judges, otherwise scoped association will
    # not be loaded
    [:form, :subject, :exact_judges, :inexact_judgings, :judges, :opponents, :proposers, :defendants, :court]
  end
end
