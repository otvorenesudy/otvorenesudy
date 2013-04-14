require 'justice_gov_sk/helper/judge_matcher'
require 'justice_gov_sk/helper/normalizer'

require 'sudnarada_gov_sk/configuration'
require 'sudnarada_gov_sk/url'
require 'sudnarada_gov_sk/storage'
require 'sudnarada_gov_sk/storage/page'
require 'sudnarada_gov_sk/storage/judge_property_declaration_page'
require 'sudnarada_gov_sk/request'
require 'sudnarada_gov_sk/request/list'
require 'sudnarada_gov_sk/request/judge_property_declaration_list'
require 'sudnarada_gov_sk/agent'
require 'sudnarada_gov_sk/agent/judge_property_declaration'
require 'sudnarada_gov_sk/parser'
require 'sudnarada_gov_sk/parser/list'
require 'sudnarada_gov_sk/parser/judge_property_declaration_list'
require 'sudnarada_gov_sk/parser/judge_property_declaration'
require 'sudnarada_gov_sk/persistor'
require 'sudnarada_gov_sk/crawler'
require 'sudnarada_gov_sk/crawler/list'
require 'sudnarada_gov_sk/crawler/judge_property_declaration_list'
require 'sudnarada_gov_sk/crawler/judge_property_declaration'
require 'sudnarada_gov_sk/base'
require 'sudnarada_gov_sk/version'

module SudnaradaGovSk
  extend SudnaradaGovSk::Base
end
