class SelectionProceduresController < SearchController
  def show
    @procedure = SelectionProcedure.find(params[:id])

    @candidates    = @procedure.candidates.order(:rank, :name)
    @commissioners = @procedure.commissioners.order(:name)

    # TODO
    # * handle storage documents for selection procedure
    # * handle storage documents for selection procedure candidate in SelectionProcedureCandidateController
  end
end
