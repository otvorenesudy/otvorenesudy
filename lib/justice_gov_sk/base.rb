# TODO
# consider distinguishing between pages and documents everywhere, like in storages
# example: Downloader::CourtPage, Parser::CourtPage?
# also consider storage/page/decree.rb vs. storage/decree_page.rb
# or remove _page suffix from storages? and leave only _document (and _list)

module JusticeGovSk
  module Base
    include Core::Base

    def source
      @source ||= Source.find_by_module self.name
    end

    # supported types: Court, CivilHearing, CriminalHearing, SpecialHearing, Decree
    def download_pages(type, options = {})
      offset = options[:offset].blank? ? 1 : options[:offset].to_i
      limit  = options[:limit].blank? ? nil : options[:limit].to_i

      request, lister = build_request_and_lister type, options

      downloader = inject JusticeGovSk::Downloader, implementation: type

      run_lister lister, request, options do
        lister.crawl(request, offset, limit) do |uri|
          call lambda { downloader.download uri }, options
        end
      end
    end

    # supported types: Decree
    def download_documents(type, options = {})
      storage = JusticeGovSk::Storage::DecreePage.instance
      request = JusticeGovSk::Request::Document.new
      agent   = JusticeGovSk::Agent::DecreeDocument.new

      extend JusticeGovSk::Helper::ContentValidator

      storage.each do |entry, bucket|
        path = File.join storage.root, bucket, entry

        print "Reading #{path} ... "

        content = File.read path

        puts "done (#{content.size} bytes)"

        request.url = entry.sub(/decree/, 'Stranky/Sudne-rozhodnutia/Sudne-rozhodnutie-detail')
        request.url = request.url.sub(/\.html/, '')
        request.url = "#{JusticeGovSk::URL.base}/#{request.url}"

        begin
          call lambda { agent.download request }, options
        rescue Exception => e
          next if e.to_s =~ /timeout/i
          raise e
        end

        valid_content? agent.storage.path(entry.sub(/html\z/, 'pdf')), :decree_pdf

        puts
      end
    end

    def run_workers(type, options = {})
      request, lister = build_request_and_lister type, options

      run_lister lister, request, options do
        puts "Running list crawler to obtain page count."

        lister.crawl(request, 1, 1) {}
      end

      puts "Running job builder."

      if lister.pages
        options = options.to_hash.merge! limit: 1

        max = options[:maximum_number_of_pages] ? options[:maximum_number_of_pages].to_i : lister.pages

        1.upto(max) do |page|
          options.merge!(offset: page)

          puts "Enqueing job for page #{page}, using #{pack options}."

          JusticeGovSk::Job::ListCrawler.perform_async(type.name, options)
        end
      end

      puts "finished (#{lister.pages} jobs)"
    end

    def run_sequential_workers(type, options = {})
      request, lister = build_request_and_lister type, options

      run_lister lister, request, options do
        puts "Running list crawler to obtain page count."

        lister.crawl(request, 1, 1) {}
      end

      puts "Running job builder."

      if lister.pages
        limit = options[:limit] || lister.pages
        options = options.to_hash.merge!(offset: 1, limit: limit.to_i)

        puts "Enqueing job for pages #{options[:offset]} to #{options[:limit]}, using #{pack options}."

        JusticeGovSk::Job::ListCrawler.perform_async(type.name, options)
      end

      puts "finished (#{lister.pages} jobs)"
    end
  end
end
