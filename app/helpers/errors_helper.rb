module ErrorsHelper
  def trace(trace)
    content_tag :pre, trace.join("\n")
  end
end
