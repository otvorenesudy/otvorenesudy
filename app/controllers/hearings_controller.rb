# frozen_string_literal: true

class HearingsController < SearchController
  before_action :set_hearing, only: %i[show anonymize]

  def show
    @court = @hearing.court
    @judges = @hearing.judges.order(:last, :middle, :first)

    @proposers = @hearing.proposers.order(:name)
    @opponents = @hearing.opponents.order(:name)
    @defendants = @hearing.defendants.includes(accusations: :paragraphs).order(:name)

    warn_about_data
  end

  # Admins only; to anyone else the action doesn't exist.
  def anonymize
    return head :not_found unless current_user&.admin?

    @hearing.anonymize!

    redirect_back_or_to hearing_path(@hearing), notice: t('.success')
  end

  private

  def set_hearing
    @hearing = Hearing.find(params.expect(:id))
  end

  def warn_about_data
    flash_now(:danger, t('.unprocessed')) if @hearing.unprocessed?
    flash_now(:danger, t('.future_date')) if @hearing.future_date?
    flash_now(:warning, t('.faulty_date')) if @hearing.future_date_when_created?
    flash_now(:warning, t('.anonymized')) if @hearing.anonymized?
  end

  # The scoped associations (exact_judges, inexact_judgings) load before the ones they scope (judges).
  def search_associations
    %i[form subject exact_judges inexact_judgings judges opponents proposers defendants court]
  end
end
