class ErrorsController < ApplicationController
  def show
    @exception = env['action_dispatch.exception']
    @message   = @exception.message

    class_name        = @exception.class.name
    rescue_response   = ActionDispatch::ExceptionWrapper.rescue_responses[class_name]
    exception_wrapper = ActionDispatch::ExceptionWrapper.new(env, @exception)

    @status = exception_wrapper.status_code
    @trace  = exception_wrapper.full_trace

    I18n.with_options scope: [:exceptions, rescue_response] do |i18n|
      key = class_name.underscore

      @error       = i18n.t "#{key}.title",       default: i18n.t(:title,       default: class_name)
      @description = i18n.t "#{key}.description", default: i18n.t(:description, default: @message)
    end

    render 'show', status: @status
  end
end
