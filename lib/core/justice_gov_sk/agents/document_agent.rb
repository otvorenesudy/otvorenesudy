module JusticeGovSk
  module Agents
    class DocumentAgent < Agent
      attr_accessor :form,
                    :form_name,
                    :document_viewer_action,
                    :document_viewer_name


      def initialize
        super
        @form_name = "aspnetForm"
      end

      def download(request)
        super(request) do |page|
          @form = page.form_with(name: @form_name)
          
          @document_viewer_name = @form.fields.map(&:name).find { |field|  field.match(/\A.+rozhodnutieSudneViewer\Z/) }
          @document_viewer_action = "saveToDisk=format:#{request.document_format.to_s}"

          @form.add_field!("__EVENTTARGET", @document_viewer_name)
          @form.add_field!("__EVENTARGUMENT", @document_viewer_action)

          return @form.submit
        end
      end
    end
  end 
end 
