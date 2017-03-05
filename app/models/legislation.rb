class Legislation < ActiveRecord::Base
  include Resource::Formatable

  attr_accessible :value,
                  :value_unprocessed,
                  :type,
                  :number,
                  :year,
                  :name,
                  :paragraph,
                  :section,
                  :letter

  has_many :usages, class_name: :LegislationUsage

  has_many :decrees, through: :usages

  has_many :paragraph_explanations, dependent: :destroy, as: :explainable

  has_many :paragraphs, through: :paragraph_explanations

  def self.inheritance_column
  end

  def external_url
    return 'http://www.zakonypreludi.sk/main/search.aspx?text=' + value unless year || number

    url = "http://www.zakonypreludi.sk/zz/#{year}-#{number}"
    url << '#p' << paragraph if paragraph
    url << '-' << section    if section
    url << '-' << letter     if letter
    url
  end

  formatable :value, default: '%t %u/%y %n %p %s %l', fixes: [-> (v) { v.sub(/[\s,]*\z/, '') }, -> (v) { v.sub(/\Azákona/, 'Zákon') }] do |legislation|
    { '%t' => legislation.type,
      '%u' => legislation.number,
      '%y' => legislation.year,
      '%n' => legislation.name,
      '%p' => ('§ ' << legislation.paragraph if legislation.paragraph),
      '%d' => legislation.paragraphs.pluck(:description).map(&:downcase_first) * ', ',
      '%s' => ('ods. ' << legislation.section if legislation.section),
      '%l' => ('písm. ' << legislation.letter << ')' if legislation.letter) }
  end

  before_save :invalidate_caches

  def invalidate_caches
    invalidate_value
  end
end
