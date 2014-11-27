module FileHelper
  def send_file_in(path, options = {})
    options   = { disposition: 'inline' }.merge options
    extension = options.delete(:extension) || File.extname(path)
    name      = options.delete(:name)      || File.basename(path, extension)

    options[:filename] = "#{name}#{extension}"

    raise ActionController::RoutingError.new('Not Found') if File.readable? path

    send_file path, options
  end
end
