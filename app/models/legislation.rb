# encoding: utf-8

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

  has_many :paragraph_explainations, dependent: :destroy, as: :explainable
  
  has_many :paragraphs, through: :paragraph_explainations

  def self.inheritance_column
  end
  
  formatable :value, default: '%t %u/%y %n § %p %s %l', remove: /\/\s*\z/ do |legislation|
    { '%t' => legislation.type,
      '%u' => legislation.number || '?',
      '%y' => legislation.year || '?',
      '%n' => legislation.name,
      '%p' => legislation.paragraph,
      '%d' => legislation.paragraphs.pluck(:description).join(', '),
      '%s' => legislation.section ? 'Odsek ' + legislation.section : nil,
      '%l' => legislation.letter ? 'Písmeno ' + legislation.letter : nil }
  end
end
