require 'spec_helper'
require 'rake'

Rake.application.rake_require 'tasks/probe'
Rake::Task.define_task :environment

def reload_indices
  Rake::Task['probe:reload']
end
