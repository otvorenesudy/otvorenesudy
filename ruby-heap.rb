# Run this with: bundle exec rbtrace -p SIDEKIQ_PID -e 'load "ruby-heap.rb"'

Thread.new do
  GC.start

  require "objspace"

  io = File.open("/tmp/ruby-heap.dump", "w")

  puts 'Generating ...'

  ObjectSpace.dump_all(output: io)

  puts 'Generated'

  io.close
end
