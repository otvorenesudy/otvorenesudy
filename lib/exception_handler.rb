module ExceptionHandler
  def self.run
    begin
      yield
    rescue Exception => e
      Rollbar.error(e)
    end
  end
end
