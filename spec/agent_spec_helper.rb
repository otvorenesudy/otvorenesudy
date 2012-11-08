require 'spec_helper'

AGENT_FIXTURES_PATH = File.join(Rails.root, "spec", "fixtures", "agent")

def remove_fixture(path)
  File.delete(path) rescue nil
end

def remove_fixtures(dir)
  FileUtils.rm_rf(dir)
end
