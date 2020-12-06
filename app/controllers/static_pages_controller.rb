class StaticPagesController < ApplicationController
  def health
    models = [Court, Judge, Hearing, Decree]

    models.each do |model|
      return render status: 422, json: { errors: ["#{model} count does not match"] } if model.count != model.total
    end

    head 204
  end

  def show
    @slug = params[:slug]

    unless @slug.in?(%[about contact copyright faq feedback privacy tos api])
      return head 404
    end

    name = @slug.gsub(/-/, '_')

    # TODO rm when we host api static page under this project
    if @slug == 'api'
      redirect_to "https://api.otvorenesudy.sk?l=#{I18n.locale}"
      return
    end

    @title    = translate "static_pages.#{name}", default: ''
    @template = "static_pages/content/#{name}"

    begin
      render
    rescue ActionView::ActionViewError => e
      exceptions = [e, e.respond_to?(:original_exception) ? e.original_exception : nil].compact
      types = exceptions.map(&:class)

      if types.include?(ActionView::MissingTemplate) || types.include?(ArgumentError)
        raise ActionController::RoutingError.new nil
      end

      raise e
    end
  end
end
