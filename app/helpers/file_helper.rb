module FileHelper
  def send_file_in(path, options = {})
    options   = options.reverse_merge(disposition: 'inline')
    extension = options.delete(:extension) || File.extname(path)
    name      = options.delete(:name)      || File.basename(path, extension)

    options[:filename] = "#{name}#{extension}"

    raise ActionController::RoutingError.new('Not Found') unless File.readable? path

    send_file path, options
  end
end
