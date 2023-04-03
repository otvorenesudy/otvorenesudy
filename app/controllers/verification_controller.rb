class VerificationController < ApplicationController
  def create
    if verify_hcaptcha
      redirect_url = session[:verify][:origin]

      session[:verify] = { verified: true, at: Time.now }

      redirect_url ? redirect_to(redirect_url) : redirect_to(:root)
    else
      flash.now[:danger] = t('verification.create.failed')

      redirect_to verification_index_path
    end
  end

  private

  def verify; end

  def verify_hcaptcha
    response = Curl.post('https://hcaptcha.com/siteverify', {
      secret: ENV['HCAPTCHA_SECRET_KEY'],
      response: params[:'h-captcha-response']
    })

    JSON.parse(response.body, symbolize_names: true)[:success]
  end
end
