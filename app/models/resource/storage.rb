# frozen_string_literal: true

# Files kept for records in the shared storage directory (Capistrano's linked `storage`):
#
#   storage(:declaration, 'documents/selection_procedures') { |procedure| "#{procedure.ic}_declaration.pdf" }
#
# defines `declaration_entry` (the file name), `declaration_path` and `declaration?` (whether the file is there).
module Resource
  module Storage
    extend ActiveSupport::Concern

    ROOT = 'storage'

    class_methods do
      def storage(name, directory, &)
        define_method("#{name}_entry") { yield(self) }
        define_method("#{name}_path") { Rails.root.join(ROOT, directory, public_send("#{name}_entry")) }
        define_method("#{name}?") { public_send("#{name}_path").file? }
      end
    end
  end
end
