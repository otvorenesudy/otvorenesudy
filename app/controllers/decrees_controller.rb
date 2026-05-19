class DecreesController < SearchController
  def show
    @decree = Decree.find(params[:id])
    @highlights = params[:h]
    @similar = @decree.similar

    @court = @decree.court
    @judges = @decree.judges.order(:last, :middle, :first)

    @legislations = @decree.legislations.order(:value)

    flash.now[:danger] << t('decrees.show.unprocessed') if @decree.unprocessed?
    flash.now[:danger] << t('decrees.show.future_date') if @decree.has_future_date?
    flash.now[:warning] << t('decrees.show.faulty_date') if @decree.had_future_date?
  end

  def uoo
    data = self.class.uoo_data
    titles_by_url = Array.wrap(data['pdfs']).each_with_object({}) { |pdf, hash| hash[pdf['url']] = pdf['title'] }

    @uoo_source_url = data['source_url']
    @uoo_decrees = Array.wrap(data['data']).map do |decree|
      decree.merge('title' => titles_by_url[decree['url']])
    end
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

  UOO_DATA_MUTEX = Mutex.new

  def self.uoo_data
    UOO_DATA_MUTEX.synchronize do
      @uoo_data ||= JSON.parse(File.read(Rails.root.join('data', 'uoo-decrees.json')))
    end
  end

  protected

  include FileHelper

  private

  def search_associations
    # NOTE do not eager load scoped associations after original associations,
    # e.g. :exact_judges has to go before :judges, otherwise scoped association will not be loaded
    %i[form legislation_areas legislation_subareas natures court exact_judges inexact_judgements judgements judges]
  end
end
