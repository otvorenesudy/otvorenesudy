# frozen_string_literal: true

# Records imported from a source website: the source and the record's address there.
module Resource
  module URI
    extend ActiveSupport::Concern

    included do
      belongs_to :source, optional: true
    end
  end
end
