# frozen_string_literal: true

# Sends a stored document of a judge selection procedure inline under a readable name, or answers 404 when it isn't
# there. Hidden with the procedures (see SelectionProceduresController).
module SelectionProcedureDocuments
  extend ActiveSupport::Concern

  private

  def send_file_in(path, options = {})
    options = options.reverse_merge(disposition: 'inline')
    extension = options.delete(:extension) || File.extname(path)
    name = options.delete(:name) || File.basename(path, extension)

    raise ActionController::RoutingError, 'Not Found' unless File.readable?(path)

    send_file path, options.merge(filename: "#{name}#{extension}")
  end
end
