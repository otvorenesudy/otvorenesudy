module JusticeGovSk
  class Agent
    class DecreeList < JusticeGovSk::Agent::List
      def download(request)
        super(request) do |page|
          form, fields = form_and_fields(page, form_name)

          # Select decree form, only for decrees
          if request.respond_to?(:decree_form_code) && request.decree_form_code
            decree_form_code_select_box_name = fields.find { |f| f.match(/\A.+cmbForma\z/) }

            field       = form.field_with(name: decree_form_code_select_box_name)
            field.value = request.decree_form_code

            page = form.submit
          end

          page
        end
      end
    end
  end
end
