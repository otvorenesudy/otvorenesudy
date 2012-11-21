# encoding: utf-8

# TODO rm
namespace :test do
  task :t1 => :environment do
    d = Downloader.new
    
    d.wait_time = nil
    d.cache_load = false
    d.cache_uri_to_path = JusticeGovSk::Requests::URL.uri_to_path_lambda
    
    d.params = data
    
    u = 'http://www.justice.gov.sk/Stranky/Sudy/SudZoznam.aspx'
    
    d.download u
  end
  
  
  task :t2 => :environment do
    d = Downloader.new
    
    d.wait_time = nil
    d.cache_load = false
    d.cache_uri_to_path = JusticeGovSk::Requests::URL.uri_to_path_lambda
    
    #c = JusticeGovSk::Crawlers::JudgeListCrawler.new d
    #r = JusticeGovSk::Requests::JudgeListRequest.new
    
    c = JusticeGovSk::Crawlers::ListCrawler.new d
    
    #r = JusticeGovSk::Requests::CourtListRequest.new
    #r = JusticeGovSk::Requests::DecreeListRequest.new
    r = JusticeGovSk::Requests::CivilHearingListRequest.new
    #r = JusticeGovSk::Requests::CriminalHearingListRequest.new
    #r = JusticeGovSk::Requests::SpecialHearingListRequest.new
    
    c.crawl_and_process r do |i|
      puts i
    end
       
  end
  
  
  task :t3 => :environment do
    d = Downloader.new
    p = Persistor.new
    
    d.wait_time = nil
    d.cache_load = false
    d.cache_uri_to_path = JusticeGovSk::Requests::URL.uri_to_path_lambda
    
    #c = JusticeGovSk::Crawlers::CourtCrawler.new d,p
    c = JusticeGovSk::Crawlers::DecreeCrawler.new d,p
    #c = JusticeGovSk::Crawlers::CivilHearingCrawler.new d,p
    #c = JusticeGovSk::Crawlers::CriminalHearingCrawler.new d,p
    #c = JusticeGovSk::Crawlers::SpecialHearingCrawler.new d,p
    
    #u = 'http://www.justice.gov.sk/Stranky/Sudy/Krajsky-sud-Kosice/SudDetail.aspx'
    #u = 'http://www.justice.gov.sk/Stranky/Sudy/Specializovany-trestny-sud/SudDetail.aspx'
    #u = 'http://www.justice.gov.sk/Stranky/Sudy/Okresny-sud-Lucenec/SudDetail.aspx'
    #u = 'http://www.justice.gov.sk/Stranky/Sudy/Krajsky-sud-Trnava/SudDetail.aspx'
    
    u = 'http://www.justice.gov.sk/Stranky/Sudne-rozhodnutia/Sudne-rozhodnutie-detail.aspx?PorCis=FFEB47A9-5F69-4DF3-84E4-45E8860E830D&PojCislo=78401'
    
    #u = 'http://www.justice.gov.sk/Stranky/Pojednavania/PojednavanieDetail.aspx?IdVp=102901109'
    #u = 'http://www.justice.gov.sk/Stranky/Pojednavania/PojednavanieTrestDetail.aspx?IdTp=EEBE32FF-A9DF-4F7F-8A4F-92A07E786D06'
    #u = 'http://www.justice.gov.sk/Stranky/Pojednavania/PojednavanieSpecDetail.aspx?IdSpecSudKonanie=3523'

    c.crawl u
  end
  

  task :t4 => :environment do 
    request = JusticeGovSk::Requests::DocumentRequest.new
    request.url = 'http://www.justice.gov.sk/Stranky/Sudne-rozhodnutia/Sudne-rozhodnutie-detail.aspx?PorCis=18D6CF82-5611-4110-A7E2-7A642784707F&PojCislo=167637'
    request.url = "http://www.justice.gov.sk/Stranky/Sudne-rozhodnutia/Sudne-rozhodnutie-detail.aspx?PorCis=A125B116-6FF4-4A8B-A787-1DC953EEE3CE&PojCislo=121420"

    agent = JusticeGovSk::Agents::DocumentAgent.new
    agent.cache_load = false
    agent.cache_store = true
    agent.cache_file_extension = request.document_format
    agent.cache_uri_to_path = JusticeGovSk::Requests::URL.uri_to_path_lambda
    agent.download(request)
  end
  
  task :stat => :environment do
    root = File.join Rails.root, 'tmp', 'cache', 'downloads'
    #root = File.join root, 'hearings'
    root = File.join root, 'hearings-distributed', 'civil'
    s = 0
    n = 0
    
    Dir.foreach(root) do |f|
      p = File.join root, f
      if !f.start_with?('.') && File.directory?(p)
        d = Dir.new(p)
        x=0
        d.each { |_| x += 1 }
        d.close
        x -= 2
        s += x
        n += 1
        
        puts "#{f} #{x}"
      end
    end
    
    puts "total -- #{s} -- avg. #{s/n}"
  end

  task :distrib => :environment do
    src = File.join Rails.root, 'tmp', 'cache', 'downloads'
    src = File.join src, 'hearings', 'civil'
    
    dst = File.join Rails.root, 'tmp', 'cache', 'downloads'
    dst = File.join dst, 'hearings-distributed', 'civil'
    
    0x00.upto(0xFF) { |i| FileUtils.mkpath File.join dst, i.to_s(16).rjust(2, '0') }
    
    Dir.foreach(src) do |f|
      sp = File.join src, f
      dp = File.join dst, (f.hash % 0xFF).to_s(16).rjust(2, '0'), f
      
      unless File.directory? sp
        FileUtils.cp sp, dp
      end
    end
  end
end
