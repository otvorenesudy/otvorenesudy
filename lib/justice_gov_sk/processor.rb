module JusticeGovSk
  class Processor
    include Core::Injector
    include Core::Processor::CSV
    include Core::Factories
    include Core::Persistor
    include JusticeGovSk::Helper::JudgeMaker
    include JusticeGovSk::Helper::JudgeMatcher
    include JusticeGovSk::Helper::Normalizer

    def process(path, options = {})
      options.merge! separator: "\t"

      read(path, options) do |record|
        yield record
      end
    end
  end
end
