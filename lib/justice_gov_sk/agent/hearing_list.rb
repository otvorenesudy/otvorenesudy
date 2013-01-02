module JusticeGovSk
  class Agent
    class HearingList < JusticeGovSk::Agent::List
      def download(request)
        super(request) do |page|
          form, fields = form_and_fields(page, form_name)

          # Include old hearings, only for hearings
          if request.respond_to?(:include_old_hearings) && request.include_old_hearings
            checkboxes = form.checkboxes.map(&:name)
            include_old_hearings_checkbox_name = checkboxes.find { |f| f.match(/\A.+StarsiePojednavania\z/) }
          end
        end
      end
    end
  end
end
