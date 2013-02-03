class Decree < ActiveRecord::Base
  include Resource::Storage
  
  attr_accessible :uri,
                  :case_number,
                  :file_number,
                  :date,
                  :ecli,
                  :text
  
  scope :at_court, lambda { |court| where court_id: court }
  
  scope :during_employment, lambda { |employment| where(court_id: employment.court).joins(:judgements).merge(Judgement.of_judge(employment.judge)) }
  
  belongs_to :proceeding
  
  belongs_to :court
  
  has_many :judgements, dependent: :destroy
  
  has_many :judges, through: :judgements
  
  belongs_to :form,   class_name: :DecreeForm,   foreign_key: :decree_form_id
  belongs_to :nature, class_name: :DecreeNature, foreign_key: :decree_nature_id
  
  belongs_to :legislation_area
  belongs_to :legislation_subarea
  
  has_many :legislation_usages
  
  has_many :legislations, through: :legislation_usages
  
# # TODO: add judgements and judges
  #mapping do
    #indexes :id
    #indexes :case_number
    #indexes :file_number
    #indexes :date
    #indexes :ecli
    #indexes :text
    
    #indexes :court,               as: lambda { |d| d.court.name if d.court                        }
    #indexes :form,                as: lambda { |d| d.form.value                                   }
    #indexes :nature,              as: lambda { |d| d.nature.value                                 }
    #indexes :legislation_area,    as: lambda { |d| d.legislation_area                             }
    #indexes :legislation_subarea, as: lambda { |d| d.legislation_subarea                          }
    #indexes :legislations,        as: lambda { |d| d.legislations.map { |l| l.legislation.value } }
  #end
  
  storage :page,           JusticeGovSk::Storage::DecreePage,     extension: :html
  storage :document,       JusticeGovSk::Storage::DecreeDocument, extension: :pdf
  storage :document_pages, JusticeGovSk::Storage::DecreeImage,    extension: :pdf
  
  def document_pages
    Dir.glob("#{document_pages_path}/*").sort
  end
end
