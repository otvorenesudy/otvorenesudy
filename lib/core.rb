require 'active_support/core_ext/hash/deep_merge'
require 'active_support/inflector'
require 'active_support/json'
require 'active_support/multibyte'

require 'ruby/string'

require 'core/configuration'
require 'core/output'
require 'core/storage/binary'
require 'core/storage/textual'
require 'core/storage'
require 'core/storage/cache'
require 'core/storage/distributed'
require 'core/storage/utils'
require 'core/processor/csv'
require 'core/version'

module Core
end
