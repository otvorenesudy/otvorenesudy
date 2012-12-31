module JusticeGovSk
  class Crawler
    include Core::Crawler
    include Core::Factories
    include Core::Identify
    include Core::Pluralize
  end
end
