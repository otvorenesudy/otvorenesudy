class LegislationSerializer < ActiveModel::Serializer
  attributes :name, :number, :letter, :paragraph, :section, :type, :year, :value, :value_unprocessed
end
