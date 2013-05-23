module JusticeGovSk
  class Processor
    include Core::Injector
    include Core::Processor::CSV
    include Core::Factories
    include Core::Persistor
    include JusticeGovSk::Helper::JudgeMaker
    include JusticeGovSk::Helper::JudgeMatcher
    include JusticeGovSk::Helper::Normalizer

    def process(filename, options = {})
      options.merge!(separator: "\t")

      @file_uri = File.basename(filename)

      read(filename, options) do |record|
        yield record
      end
    end
  end
end
