module JusticeGovSk
  module Agents
    class DocumentAgent < Agent
      def download(request)
        super(request) do |page|
          form = page.form_with(name: 'aspnetForm')
          
          document_viewer_name   = form.fields.map(&:name).find { |f|  f.match(/\A.+rozhodnutieSudneViewer\Z/) }
          document_viewer_action = "saveToDisk=format:#{request.document_format.to_s}"

          form.add_field!('__EVENTTARGET', document_viewer_name)
          form.add_field!('__EVENTARGUMENT', document_viewer_action)

          return form.submit
        end
      end
    end
  end 
end 
