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

    @historical_hearings = @judge.hearings.historical.order('date desc').limit(10)
    @upcoming_hearings   = @judge.hearings.upcoming.order('date desc').limit(10)
    @decrees             = @judge.decrees.order('date desc').limit(10)

    @related_persons = @judge.related_persons

    @results = @judge.context_search[0..9]
  end

  def curriculum
    @judge = Judge.find(params[:id])

    send_file_in @judge.curriculum_path, name: "Životopis - #{@judge.name}", escape: false
  end

  def cover_letter
    @judge = Judge.find(params[:id])

    send_file_in @judge.cover_letter_path, name: "Motivačný list - #{@judge.name}", escape: false
  end
end
