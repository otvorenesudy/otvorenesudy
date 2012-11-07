# encoding: utf-8

#<option value="A">Rozsudok </option>
#<option value="N" selected="selected">Uznesenie </option>
#option value="R">Opravné uznesenie </option>
#<option value="D">Dopĺňací rozsudok </option>
#<option value="P">Platobný rozkaz </option>
#<option value="M">Zmenkový platobný rozkaz </option>
#<option value="E">Európsky platobný rozkaz </option>
#<option value="S">Šekový platobný rozkaz </option>
#<option value="L">Rozkaz na plnenie </option>
#<option value="K">Rozsudok pre zmeškanie </option>
#<option value="U">Rozsudok pre uznanie </option>
#<option value="C">Uznesenie bez odôvodnenia </option>
#<option value="B">Osvedčenie </option>
#<option value="T">Trestný rozkaz </option>

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
    
    c = JusticeGovSk::Crawlers::CourtCrawler.new d,p
    #c = JusticeGovSk::Crawlers::DecreeCrawler.new d,p
    
    #c.verbose = nil

    u = 'http://www.justice.gov.sk/Stranky/Sudy/Krajsky-sud-Kosice/SudDetail.aspx'
    #u = 'http://www.justice.gov.sk/Stranky/Sudne-rozhodnutia/Sudne-rozhodnutie-detail.aspx?PorCis=FFEB47A9-5F69-4DF3-84E4-45E8860E830D&PojCislo=78401'

    c.crawl u
  end
  
  task :t4 => :environment do
    d = Downloader.new
    d.wait_time = nil
    d.cache_load = d.cache_store = false
    
    print 'req. 1 ... '
    r=JusticeGovSk::Requests::DecreeListRequest.new
    puts 'done'
    
    d.headers = r.headers
    d.data = r.data
    d.download r.url
    
    print 'req. 2 ... '
    r=JusticeGovSk::Requests::DecreeListRequest.new
    puts 'done' 

    d.headers = r.headers
    d.data = r.data
    d.download r.url
  end
  
end
