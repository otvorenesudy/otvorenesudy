module SudnaradaGovSk
  class Parser
    include Core::Parser::HTML
    include Core::Parser::HTML::Helper
    
    include JusticeGovSk::Helper::Normalizer
  end
end
