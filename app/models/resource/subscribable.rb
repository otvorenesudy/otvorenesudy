module Resource::Subscribable
  extend ActiveSupport::Concern

  def subscriptions
    percolate.map { |q| Query.find(q).subscriptions }.flatten
  end

  module ClassMethods
    def subscribe(id, query)
      percolator.register(id, query)
    end
  end
end
