module JusticeGovSk
  class Crawler < Core::Crawler
    include Core::Factories
    include Core::Identify
    include Core::Pluralize
  end
end
