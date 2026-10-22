# frozen_string_literal: true

# Records people can subscribe to by saving a search (decrees, hearings). Saved searches are stored in the model's
# percolator, so a record can tell which subscriptions it matches.
module Resource
  module Subscribable
    extend ActiveSupport::Concern

    class_methods do
      def subscribe(id, query)
        percolator.register(id, query)
      end

      def unsubscribe(id)
        percolator.unregister(id)
      end
    end

    def subscriptions
      Subscription.where(query_id: percolate)
    end
  end
end
