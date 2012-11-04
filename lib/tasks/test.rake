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
    
    d.params = data
    
    u = 'http://www.justice.gov.sk/Stranky/Sudy/SudZoznam.aspx'
    
    d.download u
  end
  
  
  task :t2 => :environment do
    d = Downloader.new
    
    d.wait_time = nil
    d.cache_load = false
    
    c = JusticeGovSk::Crawlers::ListCrawler.new d
    

    u = 'http://www.justice.gov.sk/Stranky/Sudy/SudZoznam.aspx'; p = {}#; p=court_params
    #u = 'http://www.justice.gov.sk/Stranky/Pojednavania/PojednavanieTrestZoznam.aspx'; p=hearing_trest_params
    # = 'http://www.justice.gov.sk/Stranky/Pojednavania/PojednavanieZoznam.aspx'; p=hearing_civil_params
    #u = 'http://www.justice.gov.sk/Stranky/Pojednavania/PojednavanieSpecZoznam.aspx'; p=hearing_special_params
    #u = 'http://www.justice.gov.sk/Stranky/Sudne-rozhodnutia/Sudne-rozhodnutia.aspx'; p=decree_params
    
    l=c.crawl u, p
    
    l.each { |i|
      puts i
    }
  end
  
  
  task :t3 => :environment do
    d = Downloader.new
    p = Persistor.new
    
    d.wait_time = nil
    d.cache_load = false
    d.cache_uri_to_path = JusticeGovSk::Config::URL.uri_to_path_lambda
    
    c = JusticeGovSk::Crawlers::CourtCrawler.new d,p

    u = 'http://www.justice.gov.sk/Stranky/Sudy/Krajsky-sud-Kosice/SudDetail.aspx'

    c.crawl u
  end
  
end
