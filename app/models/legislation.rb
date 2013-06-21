# encoding: utf-8

class Legislation < ActiveRecord::Base
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
  
  def value(format = nil)
    return super() if format.nil? || format == '%t %u/%y %n § %p Odsek %s Písmeno %l'

    @value         ||= {}
    @value[format] ||= format.gsub(/\%[tuynpdsl]/, value_parts).gsub(/(\W)\s+\z/, '').strip.squeeze(' ')
  end
  
  private
  
  def value_parts
    @name_parts ||= {
      '%t' => type,
      '%u' => number || '?',
      '%y' => year || '?',
      '%n' => name,
      '%p' => paragraph,
      '%d' => paragraphs.pluck(:description).join(', '),
      '%s' => section,
      '%l' => letter
    }
  end
end
