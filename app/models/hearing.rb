class Hearing < ActiveRecord::Base
  include Resource::Storage

#  include Tire::Model::Search
#  include Tire::Model::Callbacks

  attr_accessible :uri,
                  :case_number,
                  :file_number,
                  :date,
                  :room,
                  :special_type,
                  :commencement_date,
                  :selfjudge,
                  :note

  belongs_to :proceeding
  
  belongs_to :court
  
  has_many :judgings, dependent: :destroy
  
  has_many :judges, through: :judgings
  
  belongs_to :type,    class_name: :HearingType,    foreign_key: :hearing_type_id
  belongs_to :section, class_name: :HearingSection, foreign_key: :hearing_section_id
  belongs_to :subject, class_name: :HearingSubject, foreign_key: :hearing_subject_id
  belongs_to :form,    class_name: :HearingForm,    foreign_key: :hearing_form_id
  
  has_many :proposers,  dependent: :destroy
  has_many :opponents,  dependent: :destroy
  has_many :defendants, dependent: :destroy

  # TODO: add analyzers for other fields
#  settings analysis: { 
#            filter: {
#              name_ngram: {
#                'type'      => 'NGram',
#                'min_gram'  => 3,
#                'max_gram'  => 12
#              }
#            },
#            analyzer: {
#              name_analyzer: {
#                'type'      => 'custom',
#                'tokenizer' => 'standard',
#                'filter'    => %w(lowercase asciifolding name_ngram)
#              }
#            }
#  }

#  mapping do
#    indexes :id
#    indexes :case_number 
#    indexes :file_number
#    indexes :date
#    indexes :room
#    indexes :special_type
#    indexes :commencement_date
#
#    indexes :type,              as: lambda { |h| h.section.value                     }
#    indexes :subject,           as: lambda { |h| h.subject.value                     }
#    indexes :form,              as: lambda { |h| h.form.value                        }
#    indexes :court,             as: lambda { |h| h.court.name if court               }
#    indexes :judges,            as: lambda { |h| h.judgings.map { |j| j.judge.name } }, 
#                                analyzer: 'name_analyzer'
#    indexes :proposers,         as: lambda { |h| h.proposers.map { |p| p.name }      },
#                                analyzer: 'name_analyzer'
#    indexes :opponents,         as: lambda { |h| h.opponents.map { |o| o.name }      },
#                                analyzer: 'name_analyzer'
#    indexes :defendants,        as: lambda { |h| h.defendants.map { |d| d.name }     },
#                                analyzer: 'name_analyzer'
#  end

  storage :page, JusticeGovSk::Storage::HearingPage do |hearing|
    File.join hearing.type.name.to_s, JusticeGovSk::URL.url_to_path(hearing.uri, :html)
  end
end
