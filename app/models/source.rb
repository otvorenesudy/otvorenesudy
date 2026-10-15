# frozen_string_literal: true

class Source < ApplicationRecord
  validates :module, presence: true
  validates :name,   presence: true
  validates :uri,    presence: true

  def self.of(module_name)
    @modules ||= {}

    module_name = module_name.to_s

    @modules[module_name.to_sym] ||= find_by(module: module_name)
  end
end
