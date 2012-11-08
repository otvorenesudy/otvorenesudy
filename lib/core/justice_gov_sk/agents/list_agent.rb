module JusticeGovSk
  module Agents
    class ListAgent < Agent
      attr_accessor :form_name,
                    :per_page_field_name,
                    :page_field_name,
                    :old_records_checkbox_name,
                    :form

      def initialize
        super
        @form_name = "aspnetForm"
      end

      def postback_fields(target, argument)
        @form.add_field!("__EVENTTARGET", target)
        @form.add_field!("__EVENTARGUMENT", argument)
      end

      def download(request)
        super(request) do |page|
          @form = page.form_with(name: @form_name)
          
          # Set per_page count
          fields = @form.fields.map(&:name)
          @per_page_field_name = fields.find { |field| field.match(/\A.+cmbAGVCountOnPage\Z/) } unless @per_page_field_name

          # Check old records
          if request.include_old_records
            checkboxes = @form.checkboxes.map(&:name)
            @old_records_checkbox_name = checkboxes.find { |field| field.match(/\A.+StarsiePojednavania\Z/) } unless @old_records_field_name
            @form.checkbox_with(name: @old_records_checkbox_name).check if @old_records_checkbox_name
          end

          if request.per_page
            @form.field_with(name: @per_page_field_name).value = request.per_page if @per_page_field_name
            postback_fields(@per_page_field_name, '') 
            page = @form.submit
          end
          
          @form = page.form_with(name: @form_name)
          
          # Set page 
          fields = @form.fields.map(&:name)
          @page_field_name = fields.find { |field| field.match(/\A.+cmbAGVPager\Z/) } unless @page_field_name
          
          if request.page 
            @form.field_with(name: @page_field_name).value = request.page if @page_field_name
            postback_fields(@page_field_name, '')
            page = form.submit
          end

         page 
        end
      end
    end
  end
end
