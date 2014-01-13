module FileHelper
  def send_file_in(path, options = {})
    options   = { disposition: 'inline' }.merge options
    extension = options.delete(:extension) || File.extname(path)
    name      = options.delete(:name)      || File.basename(path, extension)
    escape    = options.delete(:escape)

    options[:filename] = "#{escape.nil? || escape ? name.gsub(/\W/, '-') : name}#{extension}"

    send_file path, options
  end
end
