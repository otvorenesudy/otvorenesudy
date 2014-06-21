class SelectionProceduresController < SearchController
  def show
    @procedure = SelectionProcedure.find(params[:id])

    # TODO
  end
end
