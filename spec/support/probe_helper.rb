class ProbeHelper
  def self.reload
    indices.each(&:reload_index)

    sleep 1
  end

  def self.delete
    indices.each(&:delete_index)

    sleep 1
  end

  private

  def self.indices
    Probe::Configuration.indices.map do |index|
      index.to_s.singularize.camelcase.constantize
    end
  end
end
