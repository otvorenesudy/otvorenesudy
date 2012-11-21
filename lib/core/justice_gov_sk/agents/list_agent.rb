module JusticeGovSk
  module Agents
    class ListAgent < Agent
      def download(request)
        super(request) do |page|
          form_name = 'aspnetForm'
          form      = page.form_with(name: form_name)
          fields    = form.fields.map(&:name)

          # Include old hearings or decrees
          if request.include_old_hearings
            checkboxes = form.checkboxes.map(&:name)
            
            include_old_hearings_checkbox_name = checkboxes.find { |f| f.match(/\A.+StarsiePojednavania\z/) }

            form.checkbox_with(name: include_old_hearings_checkbox_name).check
          end

          # Select decree form, only for decrees
          if request.decree_form
            decree_form_select_box_name = fields.find { |f| f.match(/\A.+cmbForma\z/) }
            
            field = form.field_with(:name => decree_form_select_box_name) 
            field.value = request.decree_form
          end

          form = page.form_with(name: form_name)

          # Set items per page
          per_page_field_name = fields.find { |f| f.match(/\A.+cmbAGVCountOnPage\z/) }
          
          if request.per_page
            form.field_with(name: per_page_field_name).value = request.per_page
            
            postback_fields(form, per_page_field_name, '') 
            
            print "... "
            
            page  = form.submit
            @sum += page.content.length
          end
          
          form = page.form_with(name: form_name)
          
          # Set page 
          fields = form.fields.map(&:name)
          
          page_field_name = fields.find { |f| f.match(/\A.+cmbAGVPager\z/) }
          
          if request.page 
            form.field_with(name: page_field_name).value = request.page
            
            postback_fields(form, page_field_name, '')
            
            print "... "
            
            page  = form.submit
            @sum += page.content.length
          end

          page 
        end
      end

      private
      
      def postback_fields(form, target, argument)
        form.add_field!('__EVENTTARGET', target)
        form.add_field!('__EVENTARGUMENT', argument)
      end
    end
  end
end
