module NumbersHelper
  def number_with_translation(number, options = {})
    translate options[:key], count: number < 5 ? number : number_with_delimiter(number)
  end
end
