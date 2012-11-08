module JusticeGovSk
  module Agents
    class ListAgent < Agent
      attr_accessor :per_page_field_name,
                    :page_field_name

      def initialize
        super()
        @page_field_name     = 'ctl00$ctl00$PlaceHolderMain$PlaceHolderMain$ctl01$gvPojednavanie$ctl13$ctl00$cmbAGVPager'
        @per_page_field_name  = 'ctl00$ctl00$PlaceHolderMain$PlaceHolderMain$ctl01$gvPojednavanie$ctl13$ctl00$cmbAGVCountOnPage'
      end

      def download(request)
        super(request) do |page|
          form = page.form_with(name: 'aspnetForm')
          form.field_with(name: @page_field_name).value = request.page if request.page
          form.field_with(name: @per_page_field_name).value = request.per_page if request.per_page
          form.add_field!("__EVENTTARGET", @page_field_name)
          form.add_field!("__EVENTARGUMENT", "")
          form.submit # FIREEEE!
        end
      end
    end
  end
end
