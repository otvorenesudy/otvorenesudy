class JudgeMatcher
  def match_by(name, options = {})
    name     = name.is_a?(Hash) ? name[:value] : name.to_s
    limit    = options[:similar] != nil && options[:similar] == false ? 1.0 : 0.55
    function = options[:unaccent] ? :unaccent : nil

    map = Judge.similar_by_name(name, limit: limit, function: function)

    if map.any?
      exact = map[1.0]

      if exact
        return { 1.0 => exact } unless block_given?

        exact.each do |judge|
          yield 1.0, judge
        end
      else
        return map unless block_given?

        map.each do |similarity, judges|
          judges.each do |judge|
            yield similarity, judge
          end
        end
      end
    else
      return { 0.0 => nil } unless block_given?

      yield 0.0, nil
    end
  end
end
