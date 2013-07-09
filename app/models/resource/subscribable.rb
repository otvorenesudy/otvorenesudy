module Resource::Subscribable
  extend ActiveSupport::Concern

  def subscriptions
    percolate.flat_map { |q| Query.find(q).subscriptions }
  end

  module ClassMethods
    def subscribe(id, query)
      percolator.register(id, query)
    end
  end
end
