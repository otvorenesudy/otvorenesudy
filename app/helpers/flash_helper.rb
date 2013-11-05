module FlashHelper
  def normalized_flash
    return @flash if @flash

    @flash = flash

    if defined?(resource) && (messages = resource.errors.full_messages.uniq).any?
      @flash.now[:error] = Array.wrap @flash.now[:error]

      messages.each do |message|
        @flash.now[:error] << (message.end_with?('.') ? message : message + '.')
      end
    end

    @flash
  end

  def initialize_flash_as_arrays
    flash.now[:error]  = []
    flash.now[:notice] = []
  end
end
