# frozen_string_literal: true

# Puma serves development and the browser specs; production runs under Passenger.
threads_count = ENV.fetch('RAILS_MAX_THREADS', 3)
threads threads_count, threads_count

port ENV.fetch('PORT', 3000)

plugin :tmp_restart

pidfile ENV['PIDFILE'] if ENV['PIDFILE']
