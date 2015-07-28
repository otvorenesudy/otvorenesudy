# encoding: utf-8

class CourtType < ActiveRecord::Base
  include Resource::Enumerable

  attr_accessible :value

  has_many :courts, dependent: :destroy

  validates :value, presence: true

  value :constitutional, I18n.t('court_type.constitutional')
  value :supreme,        I18n.t('court_type.supreme')
  value :specialized,    I18n.t('court_type.specialized')
  value :regional,       I18n.t('court_type.regional')
  value :district,       I18n.t('court_type.district')
end
