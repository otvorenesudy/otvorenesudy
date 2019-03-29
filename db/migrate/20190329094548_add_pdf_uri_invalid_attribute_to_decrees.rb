class AddPdfUriInvalidAttributeToDecrees < ActiveRecord::Migration
  def change
    add_column :decrees, :pdf_uri_invalid, :boolean, null: false, default: false
  end
end
