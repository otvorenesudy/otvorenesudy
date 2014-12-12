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
    object.date.try(:to_date)
  end

  def proposers
    return [] unless object.proceeding
    return [] unless object.proceeding.hearings.size > 0

    proposers = object.proceeding.hearings.map(&:proposers).flatten.uniq

    return proposers
  end

  def defendants
    return [] unless object.proceeding
    return [] unless object.proceeding.hearings.size > 0

    defendants = object.proceeding.hearings.map(&:defendants).flatten.uniq

    return defendants
  end

  def opponents
    return [] unless object.proceeding
    return [] unless object.proceeding.hearings.size > 0

    opponents = object.proceeding.hearings.map(&:opponents).flatten.uniq

    return opponents
  end
end
