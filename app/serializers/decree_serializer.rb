class DecreeSerializer < ActiveModel::Serializer
  attributes :id, :case_number, :file_number, :ecli, :text, :date, :pages_urls, :uri, :document_url, :created_at, :updated_at

  has_one :court
  has_one :form
  has_one :legislation_area
  has_one :legislation_subarea

  has_many :natures
  has_many :judges
  has_many :legislations
  has_many :defendants
  has_many :opponents
  has_many :proposers

  def pages_urls
    object.pages.map do |page|
      scope.image_decree_page_url(object, page.number)
    end
  end

  def document_url
    scope.document_decree_url(object)
  end

  def date
    object.date.to_date
  end
end
