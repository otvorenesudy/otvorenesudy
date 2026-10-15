# frozen_string_literal: true

module Probe
  # A record's document: the value of every mapped field, from its `as:` lambda or the attribute of the same name.
  module Serialize
    def to_indexed_hash
      self.class.mapping.fields.values.to_h { |field| [field.name, field.value_for(self)] }
    end
  end
end
