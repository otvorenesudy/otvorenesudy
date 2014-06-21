class SelectionProceduresController < SearchController
  def show
    @procedure = SelectionProcedure.find(params[:id])

    # TODO
    # * handle storage documents for selection procedure
    # * handle storage documents for selection procedure candidate in SelectionProcedureCandidateController
  end
end
