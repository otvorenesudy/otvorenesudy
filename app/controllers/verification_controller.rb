class VerificationController < ApplicationController

  def create
    if verify_recaptcha
      redirect_url = session[:verify][:origin]

      session[:verify] = { verified: true, at: Time.now }

      redirect_url ? redirect_to(redirect_url) : redirect_to(:root)
    else
      redirect_to verification_index_path
    end
  end

  private

  def verify; end
end
