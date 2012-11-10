module JusticeGovSk
  module Agents
    class ListAgent < Agent
      attr_accessor :form_name,
                    :per_page_field_name,
                    :page_field_name

      attr_accessor :hearing_or_decree_include_old_checkbox_name,
                    :decree_form_select_box_name

      def initialize
        super
        
        @form_name = "aspnetForm"
      end

      def download(request)
        super(request) do |page|
          @form = page.form_with(name: @form_name)
          
          fields = @form.fields.map(&:name)

          # Forms for DecreeList 
          if request.decree_form
            @decree_form_select_box_name = fields.find { |f| f.match(/\A.+cmbForma\Z/) } unless @decree_form_select_box_name
            field = @form.field_with(:name => @decree_form_select_box_name) if @decree_form_select_box_name 
            field.value = request.decree_form
          end

          # Check old records
          if request.hearing_or_decree_include_old
            checkboxes = @form.checkboxes.map(&:name)
            @hearing_or_decree_include_old_checkbox_name = checkboxes.find { |f| f.match(/\A.+StarsiePojednavania\Z/) } unless @hearing_or_decree_include_old_checkbox_name
            @form.checkbox_with(name: @hearing_or_decree_include_old_checkbox_name).check if @hearing_or_decree_include_old_checkbox_name
          end

          @form = page.form_with(name: @form_name)

          # Set per_page count
          @per_page_field_name = fields.find { |f| f.match(/\A.+cmbAGVCountOnPage\Z/) } unless @per_page_field_name
          if request.per_page
            @form.field_with(name: @per_page_field_name).value = request.per_page if @per_page_field_name
            postback_fields(@per_page_field_name, '') 
            page = @form.submit
          end
          
          @form = page.form_with(name: @form_name)
          
          # Set page 
          fields = @form.fields.map(&:name)
          @page_field_name = fields.find { |f| f.match(/\A.+cmbAGVPager\Z/) } unless @page_field_name
          
          if request.page 
            @form.field_with(name: @page_field_name).value = request.page if @page_field_name
            postback_fields(@page_field_name, '')
            page = @form.submit
          end

         page 
        end
      end

      private 
      
      def postback_fields(target, argument)
        @form.add_field!("__EVENTTARGET", target)
        @form.add_field!("__EVENTARGUMENT", argument)
      end
    end
  end
end
