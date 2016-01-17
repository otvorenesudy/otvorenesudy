class AddPdfUriToDecrees < ActiveRecord::Migration
  def change
    add_column :decrees, :pdf_uri, :string, limit: 2048
  end
end
