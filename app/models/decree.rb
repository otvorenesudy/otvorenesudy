class Decree < ActiveRecord::Base
  include Resource::Storage

  include Document::Indexable
  include Document::Searchable
  include Document::Suggestable

  attr_accessible :uri,
                  :case_number,
                  :file_number,
                  :date,
                  :ecli,
                  :text

  scope :at_court, lambda { |court| where court_id: court }

  scope :during_employment, lambda { |employment| where(court_id: employment.court).joins(:judgements).merge(Judgement.of_judge(employment.judge)) }

  belongs_to :source
  
  belongs_to :proceeding

  belongs_to :court

  has_many :judgements, dependent: :destroy

  has_many :partial_judgements, dependent: :destroy

  has_many :judges, through: :judgements

  belongs_to :form,   class_name: :DecreeForm,   foreign_key: :decree_form_id
  belongs_to :nature, class_name: :DecreeNature, foreign_key: :decree_nature_id

  belongs_to :legislation_area
  belongs_to :legislation_subarea

  has_many :legislation_usages

  has_many :legislations, through: :legislation_usages

  use_mapping do
    map     :id
    analyze :case_number
    analyze :file_number
    analyze :date,                type: 'date'
    analyze :ecli
    analyze :text,                highlight: true
    analyze :commencement_date,   type: 'date'
    analyze :court,               as: lambda { |d| d.court.name if d.court                        }
    analyze :form,                as: lambda { |d| d.form.value if d.form                         }
    analyze :nature,              as: lambda { |d| d.nature.value if d.nature                     }
    analyze :legislation_area,    as: lambda { |d| d.legislation_area.value if d.legislation_area }
    analyze :legislation_subarea, as: lambda { |d| d.legislation_subarea.value if d.legislation_subarea }
    # TODO: consider naming in singular for simplified quering
    analyze :legislations,        as: lambda { |d| d.legislations.map { |l| l.value } if d.legislations }
    analyze :judges,              as: lambda { |d| d.judges.map(&:name).concat(d.partial_judgements.map(&:judge_name)) }
  end

  use_facets do
    facet :form,                type: :terms
    facet :legislation_area,    type: :terms, size: 1000
    facet :legislation_subarea, type: :terms, size: 1000
    facet :judges,              type: :terms
    facet :court,               type: :terms
    #facet :nature,              type: :terms
    facet :date,                type: :date,  interval: :month # using default alias for interval from DateFacet
  end

  def has_future_date?
    date > Time.now.to_date
  end

  def had_future_date?
    date > created_at.to_date
  end

  storage :page,           JusticeGovSk::Storage::DecreePage,     extension: :html
  storage :document,       JusticeGovSk::Storage::DecreeDocument, extension: :pdf
  storage :document_pages, JusticeGovSk::Storage::DecreeImage,    extension: :pdf

  def document_pages
    Dir.glob("#{document_pages_path}/*").sort
  end
end
