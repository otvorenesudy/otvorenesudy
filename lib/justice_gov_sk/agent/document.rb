module JusticeGovSk
  class Agent
    class Document < JusticeGovSk::Agent
      def download(request)
        super(request) do |page|
          form = page.form_with(name: 'aspnetForm')
          
          document_viewer_name   = 'ctl00$ctl00$PlaceHolderMain$PlaceHolderMain$ctl01$rozhodnutieSudneViewer'
          document_viewer_action = "saveToDisk=format:#{request.format}"
          
          form.add_field!('__EVENTTARGET', document_viewer_name)
          form.add_field!('__EVENTARGUMENT', document_viewer_action)

          print "... "

          page  = form.submit
          @sum += page.content.length
          
          page
        end
      end
    end
  end 
end 
