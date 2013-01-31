namespace :patch do
  namespace :decrees do
    desc "Extract missing images of decree documents"
    task :extract_images => :environment do
      include Core::Output
      
      document_storage = JusticeGovSk::Storage::DecreeDocument.instance
      image_storage    = JusticeGovSk::Storage::DecreeImage.instance
      
      document_storage.each do |entry|
        unless image_storage.contains? entry
          options = { output: image_storage.path(entry) }
          
          JusticeGovSk::Extractor::Image.extract document_storage.path(entry), options
        end
      end
    end
  end
end
