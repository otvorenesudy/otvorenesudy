module NumberHelper
  def number_with_translation(number, options = {})
    translate 'numbers.' + options[:key].to_s, count: number < 5 ? number : number_with_delimiter(number)
  end
end
