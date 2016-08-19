# Require all custom Ruby core extensions

Dir[Rails.root.join 'lib', 'ruby', '*.rb'].each { |f| require f }
