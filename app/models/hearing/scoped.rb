# frozen_string_literal: true

# Hearings of one type, as their own model: `scoped_to :civil` limits CivilHearing to civil hearings.
class Hearing
  module Scoped
    extend ActiveSupport::Concern

    class_methods do
      def scoped_to(type)
        default_scope { where(hearing_type_id: HearingType.public_send(type).id) }

        define_singleton_method(:type) { HearingType.public_send(type) }
      end
    end
  end
end
